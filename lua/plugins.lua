local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local configs = "config.plugins"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup(configs, {
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { PREF.ui.colorscheme },
  },
  change_detection = { notify = false },
  ui = { border = "none" },
  dev = {
    -- directory where you store your local plugin projects
    path = "~/projects/code/personal",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {}, -- For example {"folke"}
    fallback = false, -- Fallback to git when local plugin doesn't exist
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
