return {
  "MeanderingProgrammer/markdown.nvim",
  enabled = true,
  name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  -- ft = { "markdown" },
  lazy = false,
  config = function()
    require("render-markdown").setup({
      anti_conceal = {
        enabled = true, -- show raw md on line under curson
      },
    })
  end,
}
