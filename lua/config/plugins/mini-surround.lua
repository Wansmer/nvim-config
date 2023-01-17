return {
  'Wansmer/mini.surround',
  -- dir = '~/projects/code/github/mini_surround_pr',
  -- dev = false,
  event = 'BufReadPost',
  enabled = true,
  config = function()
    require('mini.surround').setup({})
  end,
}
