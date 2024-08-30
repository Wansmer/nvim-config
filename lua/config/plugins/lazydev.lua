return {
  "folke/lazydev.nvim",
  ft = "lua",
  dependencies = {
    "neovim/nvim-lspconfig",
    { "Bilal2453/luvit-meta", lazy = true },
  },
  config = function()
    require("lazydev").setup({
      library = {
        "luvit-meta/library",
      },
    })
  end,
}
