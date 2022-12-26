return {
  'neovim/nvim-lspconfig',
  event = 'BufReadPre',
  enabled = true,
  dependencies = {
    'b0o/SchemaStore.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'williamboman/mason.nvim',
    'jayp0521/mason-null-ls.nvim',
    'williamboman/mason-lspconfig.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'j-hui/fidget.nvim',
    'dnlhc/glance.nvim',
    {
      'folke/neodev.nvim',
      config = function()
        require('neodev').setup()
      end,
    },
  },
  config = function()
    require('config.lsp')
  end,
}
