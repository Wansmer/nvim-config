return {
  'Wansmer/langmapper',
  enabled = true,
  dir = '~/projects/code/personal/langmapper',
  dev = true,
  lazy = false, -- important
  priority = 1,
  config = function()
    require('langmapper').setup()
  end,
}
