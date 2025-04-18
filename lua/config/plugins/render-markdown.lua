return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = true,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown", "pandoc", "quarto" },
  event = "BufReadPre",
  config = function()
    require("render-markdown").setup({
      heading = {
        render_modes = true,
        sign = false,
        border = true,
        border_virtual = true,
      },
      code = {
        -- render_modes = true,
        sign = false,
        language_name = true,
        border = "thin",
        above = "▄",
        below = "▀",
      },
      file_types = { "markdown", "Avante" },
      anti_conceal = {
        enabled = true, -- show raw md on line under curson
      },
      completions = { lsp = { enabled = true } },
      latex = { enabled = true },
    })
  end,
}
