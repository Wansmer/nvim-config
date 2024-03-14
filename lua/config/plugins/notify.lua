return {
  "rcarriga/nvim-notify",
  -- event = "VeryLazy",
  lazy = false,
  priority = 1,
  enabled = true,
  config = function()
    local notify = require("notify")
    vim.notify = notify
  end,
}
