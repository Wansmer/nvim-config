vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

require('user_settings')
require('options')
require('plugins')
require('mappings')
require('autocmd')
require('config.colorscheme')

-- local watcher = require('modules.watcher').new()
--
-- watcher:start()
-- watcher:on_any({
--   function()
--     vim.cmd.checktime()
--   end,
-- })
