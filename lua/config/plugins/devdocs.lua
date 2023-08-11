-- Don't forget to call `:DevdocsFetch`  during the first installation.
return {
  'luckasRanarison/nvim-devdocs',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('nvim-devdocs').setup({
      ensure_installed = {
        'rust',
        'javascript',
        'vue~3',
        'go',
        'lua~5.3',
        'html',
        'css',
      },
    })
  end,
}
