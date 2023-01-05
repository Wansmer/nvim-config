return {
  's1n7ax/nvim-window-picker',
  version = 'v1.*',
  enabled = true,
  config = function()
    local wp = require('window-picker')

    wp.setup({
      autoselect_one = true,
      include_current_win = false,
      show_prompt = false,
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
