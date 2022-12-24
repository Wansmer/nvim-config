return {
  'jose-elias-alvarez/null-ls.nvim',
  enabled = true,
  config = function()
    local null_ls = require('null-ls')

    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
    local code_actions = null_ls.builtins.code_actions

    null_ls.setup({
      on_attach = require('config.lsp.default').on_attach,
      debug = false,
      sources = {
        -- js, ts, jsx, tsx, vue
        -- NOTE: not eslint_d because it don't auto exit process when neovim closed
        diagnostics.eslint,
        code_actions.eslint,
        formatting.eslint,

        -- lua
        formatting.stylua,

        -- css/sass/scss/vue etc
        diagnostics.stylelint.with({
          extra_filetypes = { 'vue' },
        }),
        formatting.stylelint.with({
          extra_filetypes = { 'vue' },
        }),

        -- html
        formatting.prettier.with({
          filetypes = { 'html', 'json', 'markdown' },
        }),
      },
    })
  end,
}
