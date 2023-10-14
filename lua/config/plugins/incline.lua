return {
  'b0o/incline.nvim',
  enabled = false,
  event = 'VeryLazy',
  config = function()
    require('incline').setup()
  end,
}
