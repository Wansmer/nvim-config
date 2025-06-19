return {
  "neovim/nvim-lspconfig",
  enabled = true,
  event = { "BufReadPre" },
  dependencies = {
    "b0o/SchemaStore.nvim",
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("config.lsp")
  end,
}
