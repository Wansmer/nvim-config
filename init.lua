vim.loader.enable()

vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = "["

local orig_getcharstr = vim.fn.getcharstr
vim.fn.getcharstr = function() ---@diagnostic disable-line: duplicate-set-field
  local char = orig_getcharstr()
  local ok, lm = pcall(require, "langmapper.utils")
  if not ok then
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
require("modules.thincc")
require("modules.git_watcher")
require("modules.progress")
require("modules.autoimport").run()
require("modules.lazygit")
