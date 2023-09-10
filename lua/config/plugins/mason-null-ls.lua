return {
  'jayp0521/mason-null-ls.nvim',
  enabled = true,
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'jose-elias-alvarez/null-ls.nvim',
    'williamboman/mason.nvim',
  },
  config = function()
    require('mason-null-ls').setup({
      automatic_installation = true,
    })
  end,
}
