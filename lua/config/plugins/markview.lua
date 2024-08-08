return {
  "OXY2DEV/markview.nvim",
  enabled = true,
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("markview").setup({
      -- hybrid_modes = { "n" },
    })
  end,
}
