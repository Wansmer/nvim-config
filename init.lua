vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('user_settings')
require('options')
require('plugins')
require('mappings')
require('autocmd')
require('usercmd')
require('config.colorscheme')
