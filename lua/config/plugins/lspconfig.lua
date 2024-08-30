return {
  "neovim/nvim-lspconfig",
  enabled = true,
  event = { "VeryLazy" },
  dependencies = {
    "b0o/SchemaStore.nvim",
    "hrsh7th/cmp-nvim-lsp",
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      dependencies = { { "Bilal2453/luvit-meta", lazy = true } },
      config = function()
        require("lazydev").setup({
          library = {
            { path = "luvit-meta/library", words = { "vim%.uv" } },
          },
        })
      end,
    },
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("config.lsp")
  end,
}
