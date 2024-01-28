return {
  "dmmulroy/tsc.nvim",
  enabled = true,
  event = "VeryLazy",
  config = function()
    require("tsc").setup({ enable_progress_notifications = true })
  end,
}
