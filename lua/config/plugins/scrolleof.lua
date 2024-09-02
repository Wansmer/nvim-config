return {
  "Aasim-A/scrollEOF.nvim",
  enabled = true,
  event = { "CursorMoved", "WinScrolled" },
  config = function()
    require("scrollEOF").setup()
  end,
}
