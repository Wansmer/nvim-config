return {
  'mfussenegger/nvim-lint',
  enabled = true,
  event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      vue = { 'eslint_d', 'stylelint' },
      html = { 'tidy' },
      css = { 'stylelint' },
      scss = { 'stylelint' },
      less = { 'stylelint' },
    }

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
