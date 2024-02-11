return {
  "iamcco/markdown-preview.nvim",
  enabled = vim.g.vscode and false or true,
  build = "cd app && yarn install",
  ft = { "markdown" },
  config = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
}
