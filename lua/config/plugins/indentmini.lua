return {
  "nvimdev/indentmini.nvim",
  event = "BufReadPre",
  config = function()
    require("indentmini").setup({
      char = "▏",
    })
  end,
}
