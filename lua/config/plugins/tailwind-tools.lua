return {
  "luckasRanarison/tailwind-tools.nvim",
  ft = { "html", "javascript", "typescript", "css", "scss", "less", "svelte", "vue" },
  cond = false,
  event = "LspAttach",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("tailwind-tools").setup({})
  end,
}
