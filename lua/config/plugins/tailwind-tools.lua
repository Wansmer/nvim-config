return {
  "luckasRanarison/tailwind-tools.nvim",
  event = "LspAttach",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("tailwind-tools").setup({})
  end,
}
