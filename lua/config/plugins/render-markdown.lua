return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = true,
  cond = not vim.g.vscode,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "markdown", "pandoc", "quarto", "Avante", "codecompanion" },
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
      file_types = { "markdown", "Avante", "codecompanion" },
      anti_conceal = {
        enabled = true, -- show raw md on line under curson
      },
      completions = { lsp = { enabled = true } },
      latex = { enabled = false },
    })
  end,
}
