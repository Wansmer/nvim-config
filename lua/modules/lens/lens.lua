local SymbolKind = vim.lsp.protocol.SymbolKind
local u = require('utils')

local SYMBOLS = 'textDocument/documentSymbol'
local REFERENCES = 'textDocument/references'
local ns = vim.api.nvim_create_namespace('__symbol_usage__')

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
---@param state_id string
---@param state table
---@return Lens
function Lens.new(bufnr, client, state_id, state)
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
    state_id = state_id,
    state = state,
    potrogano = {},
  }, Lens)
end

local function make_params(ref)
  return {
    context = { includeDeclaration = false },
    position = ref.selectionRange.start,
    textDocument = { uri = vim.uri_from_bufnr(0) },
  }
end

local function set_extmark(bufnr, line, opts)
  return vim.api.nvim_buf_set_extmark(bufnr, ns, line, 0, opts)
end

function Lens:run()
  if self:support_client() then
    self:collect_symbols()
  end
end

function Lens:support_client()
  local is_symbols = self.client.supports_method(SYMBOLS, { bufnr = self.bufnr })
  local is_references = self.client.supports_method(REFERENCES, { bufnr = self.bufnr })
  if is_symbols and is_references then
    return true
  end
  return false
end

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

function Lens:filter(symbols, prefix)
  for _, symbol in ipairs(symbols) do
    if symbol.children then
      self:filter(symbol.children, symbol.name)
    end

    if u.list_contains(self.kinds, symbol.kind) then
      table.insert(self.symbols, {
        id = prefix .. '>' .. symbol.name,
        params = make_params(symbol),
      })
    end
  end
end

function Lens:clear_irrelevant_extmark(times)
  return function(i)
    if i == times then
      for key, data in pairs(self.state:get_buffer(self.state_id)) do
        if not self.potrogano[key] then
          vim.api.nvim_buf_del_extmark(self.bufnr, ns, data.id)
          self.state:del_record(self.state_id, key)
        end
      end
    end
  end
end

function Lens:collect_references()
  local cb = self:clear_irrelevant_extmark(#self.symbols)
  for i, sym in ipairs(self.symbols) do
    local function handler(err, response)
      if not err and response then
        self:show({ symbol_id = sym.id, references = #response, line = sym.params.position.line })
      end
      cb(i)
    end

    self.client.request(REFERENCES, sym.params, handler, self.bufnr)
  end
end

function Lens:show(opts)
  if opts.references ~= 0 then
    local record = self.state:get_record(self.state_id, opts.symbol_id)

    local ext_opts = {
      virt_text = { { ' ' .. opts.references .. ' usage', 'Comment' } },
      virt_text_pos = 'eol',
      hl_mode = 'combine',
    }

    ext_opts.id = record and record.id or nil
    local id = set_extmark(self.bufnr, opts.line, ext_opts)
    self.state:set_record(self.state_id, opts.symbol_id, { id = id })

    self.potrogano[opts.symbol_id] = { id = id }
  end
end

return Lens
