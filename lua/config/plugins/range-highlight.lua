return {
  "winston0410/range-highlight.nvim",
  enabled = true,
  event = { "CmdlineEnter" },
  dependencies = { "winston0410/cmd-parser.nvim" },
  config = function()
    require("range-highlight").setup({})
  end,
}
