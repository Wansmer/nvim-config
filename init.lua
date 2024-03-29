vim.loader.enable()

vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = "["

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
