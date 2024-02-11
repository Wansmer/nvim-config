return {
  "nvim-treesitter/playground",
  event = "BufReadPost",
  enabled = vim.g.vscode and false or true,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}
