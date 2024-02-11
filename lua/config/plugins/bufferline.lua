return {
  "akinsho/bufferline.nvim",
  enabled = vim.g.vscode and false or true,
  version = "*",
  event = "VeryLazy",
  config = function()
    require("bufferline").setup({
      options = {
        diagnostics = false,
        offsets = { { filetype = "neo-tree", text = "File Explorer" } },
      },
    })
  end,
}
