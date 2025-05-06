local DEV = false

return {
  "Wansmer/langmapper.nvim",
  enabled = true,
  lazy = false,
  dir = DEV and "~/projects/code/personal/langmapper.nvim" or nil,
  dev = DEV,
  config = function()
    local lm = require("langmapper")
    lm.setup()
    lm.hack_get_keymap()
  end,
}
