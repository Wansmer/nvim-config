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

local missnode_adder = require('modules.missnode_adder')

vim.api.nvim_create_autocmd('FileType', {
  pattern = missnode_adder.get_langs(),
  callback = function()
    vim.api.nvim_create_autocmd('ModeChanged', {
      pattern = 'i:n',
      callback = missnode_adder.insert_missing,
    })
  end,
})
