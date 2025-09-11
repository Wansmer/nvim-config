return {
  "luckasRanarison/tailwind-tools.nvim",
  cond = false,
  event = "LspAttach",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("tailwind-tools").setup({})
  end,
}
