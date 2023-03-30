return {
  'Wansmer/langmapper',
  enabled = true,
  dir = '~/projects/code/personal/langmapper',
  dev = true,
  lazy = true, -- important
  priority = 1,
  config = function()
    require('langmapper').setup()
  end,
}
