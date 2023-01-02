return {
  'Wansmer/langmapper',
  enabled = true,
  dir = '~/projects/code/personal/langmapper',
  dev = true,
  lazy = false,
  priority = 2,
  config = function()
    require('langmapper').setup()
  end,
}
