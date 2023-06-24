vim.loader.enable()

vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = '['

require('user_settings')
require('options')
require('plugins')
require('config.colorscheme')
require('mappings')
require('autocmd')
require('modules.thincc')

vim.api.nvim_set_hl(0, 'LspInlayHint', { link = 'Comment' })
