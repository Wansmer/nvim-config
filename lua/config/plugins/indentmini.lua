return {
  "nvimdev/indentmini.nvim",
  enabled = false,
  event = "BufReadPre",
  config = function()
    require("indentmini").setup({
      char = "▏",
    })
  end,
}
