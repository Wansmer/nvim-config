vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('user_settings')
require('options')
require('plugins')
require('mappings')
require('autocmd')
require('config.colorscheme')

local watcher = require('modules.watcher').new()

watcher:on_every_event(function()
  vim.cmd.checktime()
end)

watcher:watch()
