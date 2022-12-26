return {
  'neovim/nvim-lspconfig',
  event = 'BufReadPre',
  enabled = true,
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'dnlhc/glance.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    'williamboman/mason.nvim',
    'jayp0521/mason-null-ls.nvim',
    'j-hui/fidget.nvim',
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
