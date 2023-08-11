return {
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-tree/nvim-web-devicons' },
  {
    'echasnovski/mini.splitjoin',
    config = function()
      require('mini.splitjoin').setup()
    end,
  },
}
