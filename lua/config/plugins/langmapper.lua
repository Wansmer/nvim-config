return {
  'Wansmer/langmapper',
  enabled = true,
  -- dir = '~/projects/code/personal/langmapper',
  -- dev = false,
  lazy = false,
  priority = 1,
  config = function()
    require('langmapper').setup()
  end,
}
