return {
  'stevearc/conform.nvim',
  enabled = true,
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Use a sub-list to run only the first available formatter
        javascript = { { 'prettierd', 'prettier' }, 'eslint_d' },
        javascriptreact = { { 'prettierd', 'prettier' }, 'eslint_d' },
        typescript = { { 'prettierd', 'prettier' }, 'eslint_d' },
        typescriptreact = { { 'prettierd', 'prettier' }, 'eslint_d' },
        html = { { 'prettierd', 'prettier' } },
        json = { { 'prettierd', 'prettier' } },
        markdown = { { 'prettierd', 'prettier' } },
        toml = { { 'prettierd', 'prettier' } },
      },
    })
  end,
}
