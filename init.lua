require('user_settings')
require('options')

-- Установка лидера
vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('plugins')
require('mappings')
require('autocmd')
require('config.colorscheme')
