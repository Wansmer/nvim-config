local SymbolKind = vim.lsp.protocol.SymbolKind

local SYMBOLS = 'textDocument/documentSymbol'
local REFERENCES = 'textDocument/references'
local ns = vim.api.nvim_create_namespace('__symbol_usage__')

local chl = vim.api.nvim_get_hl(0, { name = 'Comment' })
vim.api.nvim_set_hl(0, 'SymbolUsageText', { fg = chl.fg })

---@class Lens
---@field bufnr integer
---@field client lsp.Client
---@field kinds lsp.SymbolKind
---@field symbols table
---@field state_id string
---@field state State
---@field potrogano table
local Lens = {}
Lens.__index = Lens

---Found references and print it
---@param bufnr integer
---@param client lsp.Client
---@param state State
---@return Lens
function Lens.new(bufnr, client, state)
  return setmetatable({
    bufnr = bufnr,
    client = client,
    kinds = {
      SymbolKind.Function,
      SymbolKind.Method,
      SymbolKind.Class,
      SymbolKind.Interface,
      SymbolKind.Struct,
    },
    symbols = {},
    state_id = bufnr .. vim.uri_from_bufnr(bufnr),
    state = state,
    potrogano = {},
  }, Lens)
end

---Make params form 'textDocument/references' request
---@param ref table
---@return table
local function make_params(ref)
  return {
    context = { includeDeclaration = false },
    position = ref.selectionRange['end'],
    textDocument = { uri = vim.uri_from_bufnr(0) },
  }
end

local function set_extmark(bufnr, line, opts)
  opts = vim.tbl_extend('force', { virt_text_pos = 'eol', hl_mode = 'combine' }, opts)
  return vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, opts)
end

---Checks buffer and print virtual text with symbol usage information
function Lens:run()
  if self:support_client() then
    -- local state = self.state:get_buffer(self.state_id)
    -- if state then
    --   for _, record in pairs(state) do
    --     set_extmark(self.bufnr, record.line, { id = record.id })
    --   end
    -- end
    self:collect_symbols()
  end
end

---Checks if client support required lsp methods
---@return boolean
function Lens:support_client()
  local is_symbols = self.client.supports_method(SYMBOLS, { bufnr = self.bufnr })
  local is_references = self.client.supports_method(REFERENCES, { bufnr = self.bufnr })
  if is_symbols and is_references then
    return true
  end
  return false
end

---Collect textDocument symbols
function Lens:collect_symbols()
  local function handler(err, response)
    if not err and response then
      self:filter(response, '')
    end

    self:collect_references()
  end

  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  self.client.request(SYMBOLS, params, handler, self.bufnr)
end

---Filters textDocument symbols by specific lsp kinds
---@param symbols table Dict of symbols
---@param prefix string Name of parent symbol to create unique symbol id
function Lens:filter(symbols, prefix)
  for _, symbol in ipairs(symbols) do
    if symbol.children then
      self:filter(symbol.children, symbol.name)
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    if vim.list_contains(self.kinds, symbol.kind) then
      table.insert(self.symbols, {
        id = prefix .. '>' .. symbol.name,
        params = make_params(symbol),
      })
    end
  end
end

-- detail = "function (symbols, prefix)",
-- kind = 6,
-- name = "Lens:filter",
-- range = {
--   ["end"] = {
--     character = 3,
--     line = 111
--   },
--   start = {
--     character = 0,
--     line = 94
--   }
-- },
-- selectionRange = {
--   ["end"] = {
--     character = 20,
--     line = 94
--   },
--   start = {
--     character = 9,
--     line = 94
--   }
-- }

---@alias ClearExtmarkCB function(idx: integer): void

---Deletes irrelevant extmark and dependent records in state
---@param count integer Number of watched symbols in buffer
---@return ClearExtmarkCB Callback to execute after last symbol is processed
function Lens:clear_irrelevant_extmark(count)
  return function(idx)
    if idx == count then
      for key, data in pairs(self.state:get_buffer(self.state_id)) do
        if not self.potrogano[key] then
          vim.api.nvim_buf_del_extmark(self.bufnr, ns, data.id)
          self.state:del_record(self.state_id, key)
        end
      end
    end
  end
end

---Collects references to symbols in the document
function Lens:collect_references()
  local cb = self:clear_irrelevant_extmark(#self.symbols)
  for i, sym in ipairs(self.symbols) do
    local function handler(err, response)
      if not err and response then
        self:print_extmark({
          symbol_id = sym.id,
          ref_count = #response,
          line = sym.params.position.line,
        })
      end
      cb(i)
    end

    self.client.request(REFERENCES, sym.params, handler, self.bufnr)
  end
end

---Prints extmarks
---@param data table
function Lens:print_extmark(data)
  if data.ref_count ~= 0 then
    local record = self.state:get_record(self.state_id, data.symbol_id)

    local opts = {
      virt_text = { { ' ' .. data.ref_count .. ' usage', 'SymbolUsageText' } },
    }

    opts.id = record and record.id or nil
    local record_data = {
      id = set_extmark(self.bufnr, data.line, opts),
      ref_count = data.ref_count,
      line = data.line,
    }
    self.state:set_record(self.state_id, data.symbol_id, record_data)
    self.potrogano[data.symbol_id] = record_data
  end
end

return Lens
