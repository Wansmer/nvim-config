-- Shows usage count for functions, methods, class, structs, and interface on the same line
-- Knowleges: https://github.com/VidocqH/lsp-lens.nvim/blob/main/lua/lsp-lens/init.lua

local SymbolKind = vim.lsp.protocol.SymbolKind
local u = require('utils')
local ns = vim.api.nvim_create_namespace('__lens__')

-- Full list: https://github.com/neovim/neovim/blob/1f551e068f728ff38bd7fdcfa3a6daf362bab9da/runtime/lua/vim/lsp/protocol.lua#L119
local target_kinds = {
  SymbolKind.Function,
  SymbolKind.Method,
  SymbolKind.Class,
  SymbolKind.Interface,
  SymbolKind.Struct,
}

local function supports_method(method, bufnr)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.supports_method(method, { bufnr = bufnr }) then
      return true
    end
  end
  return false
end

local function show_usage(bufnr, id, res)
  local ln = res.range.start.line
  local text = vim.api.nvim_buf_get_lines(bufnr, ln, ln + 1, true)[1]
  local len = vim.fn.strchars(text)

  vim.api.nvim_buf_set_extmark(bufnr, ns, ln, 0, {
    id = id,
    virt_text = { { res.references .. ' usage', 'Comment' } },
    virt_text_pos = 'overlay',
    virt_text_win_col = len + 2,
    hl_mode = 'combine',
  })
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
    local method = 'textDocument/references'

    local function handler(response)
      for _, resp in ipairs(response) do
        if not resp.error and resp.result then
          show_usage(bufnr, idx, { name = sym.name, references = #resp.result, range = sym.range })
        end
      end
    end

    if supports_method(method, bufnr) then
      vim.lsp.buf_request_all(bufnr, method, sym.params, handler)
    end
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
  local method = 'textDocument/documentSymbol'
  local symbols = {}

  local function handler(response)
    for _, resp in ipairs(response) do
      if not resp.error and resp.result then
        filter_by_kinds(symbols, resp.result)
      end
    end

    collect_references(symbols, bufnr)
  end

  if supports_method(method, bufnr) then
    local params = { textDocument = vim.lsp.util.make_text_document_params() }
    vim.lsp.buf_request_all(bufnr, method, params, handler)
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
