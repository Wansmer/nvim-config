return {
  {
    'nvim-lua/plenary.nvim',
    enabled = true,
  },
  {
    'nvim-tree/nvim-web-devicons',
    enabled = true,
  },
  {
    'echasnovski/mini.splitjoin',
    enabled = true,
    config = function()
      require('mini.splitjoin').setup()
    end,
  },
}
