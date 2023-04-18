-- Default settings for each server
local M = {}

local set_keymaps = require('config.lsp.mappings').set_keymap

M.on_attach = function(client, bufnr)
  -- Enable formatting for ranges
  vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

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
capabilities.semanticTokensProvider = nil

M.capabilities = capabilities

return M
