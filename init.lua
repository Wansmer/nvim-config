vim.loader.enable()

if vim.fn.has("nvim-0.12") == 1 then
  require("vim._extui").enable({})
else
  require("modules.router")
end

vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = "["
vim.g.python3_host_prog = vim.fn.expand("~/.virtualenvs/neovim/bin/python3")

local orig_getcharstr = vim.fn.getcharstr
vim.fn.getcharstr = function() ---@diagnostic disable-line: duplicate-set-field
  local char = orig_getcharstr()
  local u = require("utils")
  local ok, lm = pcall(require, "langmapper.utils")
  if not ok or u.layout.is_en() then
    return char
  end

  return lm.translate_keycode(char, "default", "ru")
end

require("user_settings")
require("options")
require("plugins")

require("config.colorscheme")
require("mappings")
require("autocmd")
require("filetype")
require("modules.thincc")
require("modules.git_watcher")
require("modules.progress")
require("modules.autoimport").run()
require("modules.fftt").setup()
require("modules.marks").setup()
require("modules.improve-visual-block").setup()
require("modules.punto-switcher")
require("modules.devcontainer").start()
