return {
  's1n7ax/nvim-window-picker',
  -- tag = 'v1.*',
  enabled = true,
  config = function()
    local wp = require('window-picker')

    wp.setup({
      autoselect_one = true,
      include_current = false,
      filter_rules = {
        bo = {
          filetype = {
            'neo-tree',
            'neo-tree-popup',
            'notify',
            'quickfix',
            'toggleterm',
          },
          buftype = { 'terminal', 'toggleterm' },
        },
      },
      other_win_hl_color = '#e35e4f',
    })
  end,
}
