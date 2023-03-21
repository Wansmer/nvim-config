vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

local load = {
  'user_settings',
  'options',
  'plugins',
  'mappings',
  'autocmd',
  'config.colorscheme',
}

for _, to_load in ipairs(load) do
  require(to_load)
end

local watcher = require('modules.watcher').new()

watcher:start()
watcher:on_any({
  function()
    vim.cmd.checktime()
  end,
})

vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')

local ok, lm = pcall(require, 'langmapper')
if ok then
  lm.automapping()
end
