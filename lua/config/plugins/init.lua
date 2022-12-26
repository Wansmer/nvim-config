return {
  {
    'nvim-lua/plenary.nvim',
    lazy = false,
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = false,
    config = function()
      require('nvim-web-devicons').setup({ default = true })
    end,
  },
}
