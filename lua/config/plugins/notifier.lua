return {
  "vigoux/notifier.nvim",
  event = "VeryLazy",
  enabled = false,
  config = function()
    require("notifier").setup({
      -- You configuration here
    })
  end,
}
