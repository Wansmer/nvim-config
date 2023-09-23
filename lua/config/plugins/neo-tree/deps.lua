return {
  'nvim-lua/plenary.nvim',
  'nvim-tree/nvim-web-devicons',
  'MunifTanjim/nui.nvim',
  {
    's1n7ax/nvim-window-picker',
    version = 'v1.*',
    config = function()
      local picker = require('window-picker')

      local lm_ok, lm_utils = pcall(require, 'langmapper.utils')
      if lm_ok then
        ---@diagnostic disable-next-line: duplicate-set-field
        require('window-picker.util').get_user_input_char = function()
          local char = vim.fn.getcharstr()
          return lm_utils.translate_keycode(char, 'default', 'ru')
        end
      end

      picker.setup({
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
              'qf',
              'toggleterm',
              'aerial',
            },
            buftype = { 'terminal', 'toggleterm' },
          },
        },
        other_win_hl_color = '#e35e4f',
      })
    end,
  },
}
