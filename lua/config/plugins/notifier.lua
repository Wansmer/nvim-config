return {
  "vigoux/notifier.nvim",
  event = "VeryLazy",
  enabled = vim.g.vscode and false or true,
  config = function()
    require("notifier").setup({
      -- You configuration here
    })
  end,
}
