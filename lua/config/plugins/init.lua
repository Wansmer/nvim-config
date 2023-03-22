return {
  { 'nvim-lua/plenary.nvim' },
  {
    'nvim-tree/nvim-web-devicons',
  },
  {
    'projekt0n/circles.nvim',
    dependencies = 'nvim-web-devicons',
    config = function()
      require('circles').setup()
    end,
  },
  { 'nvim-treesitter/playground' },
}
