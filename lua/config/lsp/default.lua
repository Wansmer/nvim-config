-- Default settings for each server
local M = {}

local set_keymaps = require('config.lsp.mappings').set_keymap

---Lsp attach callback
---@param client lsp.Client
---@param bufnr integer
M.on_attach = function(client, bufnr)
  -- Enable formatting for ranges
  if vim.fn.has('nvim-0.10.0') then
    vim.api.nvim_set_option_value('formatexpr', 'v:lua.vim.lsp.formatexpr()', { buf = bufnr })
  else
    ---@diagnostic disable-next-line: redundant-parameter
    vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
  end

  -- Disable semantic tokens highlight
  if client.server_capabilities.semanticTokensProvider then
    -- Disable
    -- client.server_capabilities.semanticTokensProvider = nil
    -- Enable
    vim.lsp.semantic_tokens.start(bufnr, client.id)
  end

  set_keymaps(client, bufnr)

  -- Disables built-in LSP formatters if null-ls provides specials formatters for current filetype
  require('config.lsp.formatters').setup(client, bufnr)
end

M.autostart = true

M.single_file_support = true

M.flags = {
  debounce_text_changes = 150,
}

-- nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Luasnip
capabilities.textDocument.completion.completionItem.snippetSupport = true

M.capabilities = capabilities

return M
