vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

require('user_settings')
require('options')
require('plugins')
require('mappings')
require('autocmd')
require('config.colorscheme')

-- TODO: перенести в отдельный модуль
local w = vim.loop.new_fs_event()
if w then
  local CWD = vim.loop.cwd()

  local Watcher = {}

  local function wrapper()
    vim.schedule_wrap(function(...)
      Watcher.on_change(...)
    end)
  end

  Watcher.on_change = function(err, fname, status)
    vim.api.nvim_command('checktime')
    w:stop()
    Watcher.watch_file(CWD)
  end

  Watcher.watch_file = function(path, cb)
    w:start(path, {}, cb)
  end

  Watcher.watch_file(CWD, wrapper)
end
