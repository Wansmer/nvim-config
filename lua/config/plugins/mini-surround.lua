return {
  'Wansmer/mini.surround',
  event = 'BufReadPost',
  enabled = true,
  config = function()
    require('mini.surround').setup()
  end,
}
