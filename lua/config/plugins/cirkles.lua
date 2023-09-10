return {
  'projekt0n/circles.nvim',
  enabled = true,
  event = 'VeryLazy',
  requires = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('circles').setup()
  end,
}
