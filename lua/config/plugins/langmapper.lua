return {
  'Wansmer/langmapper',
  dir = '~/projects/code/personal/langmapper',
  enabled = true,
  dev = true,
  lazy = false,
  priority = 2,
  config = function()
    require('langmapper').setup()
  end,
}
