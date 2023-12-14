return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  enabled = false,
  config = function()
    local notify = require("notify")
    vim.notify = notify
  end,
}
