-- Shows usage count for functions, methods, class, structs, and interface on the same line
-- Knowleges: https://github.com/VidocqH/lsp-lens.nvim/blob/main/lua/lsp-lens/init.lua

-- TODO:
-- [ ] ignore anonimus func

local SymbolKind = vim.lsp.protocol.SymbolKind
local u = require('utils')
local ns = vim.api.nvim_create_namespace('__lens__')

local SYMBOLS = 'textDocument/documentSymbol'
local REFERENCES = 'textDocument/references'

-- Full list: https://github.com/neovim/neovim/blob/1f551e068f728ff38bd7fdcfa3a6daf362bab9da/runtime/lua/vim/lsp/protocol.lua#L119
local target_kinds = {
  SymbolKind.Function,
  SymbolKind.Method,
  SymbolKind.Class,
  SymbolKind.Interface,
  SymbolKind.Struct,
  -- SymbolKind.Variable,
}

local function supports_methods(bufnr)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    local is_symbols = client.supports_method(SYMBOLS, { bufnr = bufnr })
    local is_references = client.supports_method(REFERENCES, { bufnr = bufnr })
    if is_symbols and is_references then
      return true
    end
  end
  return false
end

local function show_usage(bufnr, id, res)
  local ln = res.range.start.line

  if res.references ~= 0 then
    vim.api.nvim_buf_set_extmark(bufnr, ns, ln, 0, {
      id = id,
      virt_text = { { ' ' .. res.references .. ' usage', 'Comment' } },
      virt_text_pos = 'eol',
      hl_mode = 'combine',
    })
  end
end

local function make_params(ref)
  return {
    context = { includeDeclaration = false },
    position = ref.selectionRange.start,
    textDocument = { uri = vim.uri_from_bufnr(0) },
  }
end

local function collect_references(symbols, bufnr)
  for idx, sym in ipairs(symbols) do
    local function handler(response)
      for _, resp in ipairs(response) do
        if not resp.error and resp.result then
          show_usage(bufnr, idx, {
            name = sym.name,
            references = #resp.result,
            range = sym.range,
          })
        end
      end
    end

    vim.lsp.buf_request_all(bufnr, REFERENCES, sym.params, handler)
  end
end

local function filter_by_kinds(dst, symbols)
  for _, symbol in ipairs(symbols) do
    if symbol.children then
      filter_by_kinds(dst, symbol.children)
    end

    if u.list_contains(target_kinds, symbol.kind) then
      table.insert(dst, {
        name = symbol.name,
        params = make_params(symbol),
        range = symbol.selectionRange,
      })
    end
  end
end

local function collect_document_symbols(bufnr)
  -- local method = 'textDocument/documentSymbol'
  local symbols = {}

  local function handler(response)
    for _, resp in ipairs(response) do
      if not resp.error and resp.result then
        filter_by_kinds(symbols, resp.result)
      end
    end

    collect_references(symbols, bufnr)
  end

  if supports_methods(bufnr) then
    local params = { textDocument = vim.lsp.util.make_text_document_params() }
    vim.lsp.buf_request_all(bufnr, SYMBOLS, params, handler)
  end
end

local Lens = {}

function Lens.attach(bufnr)
  collect_document_symbols(bufnr)
end

vim.api.nvim_create_autocmd({ 'LspAttach', 'BufEnter', 'TextChanged' }, {
  callback = function(event)
    Lens.attach(event.buf)
  end,
})
