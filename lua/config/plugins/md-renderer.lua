return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- ft = { "markdown" },
  lazy = false,
  config = function()
    require("render-markdown").setup({})
  end,
}
