return {
  'neovim/nvim-lspconfig',
  event = {
    'BufEnter',
    'BufReadPre',
    'BufNewFile',
  },
  enabled = true,
  dependencies = {
    'b0o/SchemaStore.nvim',
    'hrsh7th/cmp-nvim-lsp',
    {
      'folke/neodev.nvim',
      config = function()
        require('neodev').setup({})
      end,
    },
    'mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  config = function()
    require('config.lsp')
  end,
}
