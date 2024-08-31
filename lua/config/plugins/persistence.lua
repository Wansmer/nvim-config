return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  enabled = true,
  config = function()
    require("persistence").setup({})
  end,
}
