return {
  "neovim/nvim-lspconfig",
  enabled = true,
  event = { "BufReadPre" },
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
