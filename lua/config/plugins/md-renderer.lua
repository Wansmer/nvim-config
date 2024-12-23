return {
  "MeanderingProgrammer/markdown.nvim",
  enabled = true,
  name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown" },
  event = "BufReadPre",
  config = function()
    require("render-markdown").setup({
      file_types = { "markdown", "Avante" },
      anti_conceal = {
        enabled = true, -- show raw md on line under curson
      },
    })
  end,
}
