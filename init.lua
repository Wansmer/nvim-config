require('user_settings')
require('options')
require('mappings')
require('plugins')
require('autocmd')
require('config.colorscheme')

-- local function get_current_layout()
--   local keyboar_key = '"KeyboardLayout Name"'
--   local cmd = 'defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | egrep -w ' .. keyboar_key
--   local output = vim.fn.system(cmd)
--   local cur_layout = vim.trim(output:match('%"KeyboardLayout Name%" = (%a+);'))
--   return cur_layout
-- end
--
-- local function test_ru()
--   print('RU')
-- end
-- local function test_en()
--   print('Current: ', get_current_layout())
--   print('EN')
-- end
--
-- local function feed_system(keycode)
--   return function ()
--     local layout = get_current_layout()
--     if layout == 'RussianWin' then
--       vim.api.nvim_feedkeys(keycode, 'n', true)
--     end
--   end
-- end
--
-- vim.keymap.set('n', '<leader><leader>', feed_system(':'))
