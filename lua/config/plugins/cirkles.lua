return {
  'projekt0n/circles.nvim',
  enabled = false,
  event = 'VeryLazy',
  requires = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('circles').setup()
  end,
}
