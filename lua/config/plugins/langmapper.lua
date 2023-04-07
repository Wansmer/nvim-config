local DEV = false

return {
  'Wansmer/langmapper',
  enabled = true,
  dir = DEV and '~/projects/code/personal/langmapper' or nil,
  dev = DEV,
  lazy = false,
  priority = 1,
  config = function()
    require('langmapper').setup()
  end,
}
