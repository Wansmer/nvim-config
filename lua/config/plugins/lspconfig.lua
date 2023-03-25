return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  enabled = true,
  dependencies = {
    'b0o/SchemaStore.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    {
      'folke/neodev.nvim',
      config = function()
        require('neodev').setup({ { experimental = { pathStrict = true } } })
      end,
    },
  },
  config = function()
    require('config.lsp')
  end,
}
