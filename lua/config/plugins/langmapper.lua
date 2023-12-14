local DEV = false

return {
  "Wansmer/langmapper",
  enabled = true,
  dir = DEV and "~/projects/code/personal/langmapper" or nil,
  dev = DEV,
  priority = 1,
  config = function()
    local lm = require("langmapper")
    lm.setup()
    lm.hack_get_keymap()
  end,
}
