local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local configs = 'config.plugins'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup(configs, {
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { PREF.ui.colorscheme },
  },
  ui = { border = 'none' },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
