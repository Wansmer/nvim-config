return {
  "antosha417/nvim-lsp-file-operations",
  enabled = true,
  event = { "LspAttach" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neo-tree/neo-tree.nvim",
  },
  config = function()
    require("lsp-file-operations").setup()
  end,
}
