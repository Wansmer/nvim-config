return {
  "neovim/nvim-lspconfig",
  enabled = true,
  event = { "VeryLazy" },
  dependencies = {
    "b0o/SchemaStore.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("config.lsp")
  end,
}
