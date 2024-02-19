return {
  "folke/trouble.nvim",
  enabled = true,
  cmd = { "TroubleToggle", "Trouble" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({})
  end,
}
