local present, null_ls = pcall(require, 'null-ls')
if not present then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
  on_attach = require('config.lsp.default').on_attach,
  debug = false,
  sources = {
    -- js, ts
    diagnostics.eslint_d,
    code_actions.eslint_d,
    formatting.eslint_d,

    -- lua
    formatting.stylua,

    -- css/sass/scss etc
    diagnostics.stylelint,
    formatting.stylelint,

    -- markdown
    formatting.markdownlint,
  },
})
