return {
  "Wansmer/clonewin.nvim",
  enabled = true,
  lazy = false,
  dev = true,
  cond = not vim.g.vscode,
  dir = "~/projects/code/personal/clonewin",
  config = function()
    require("clonewin.init").setup({
      mappings = {
        ["<C-h>"] = "<C-h>",
        ["<C-j>"] = "<C-j>",
        ["<C-k>"] = "<C-k>",
        ["<C-l>"] = "<C-l>",
        ["<C-;>"] = "<C-;>",
      },
    })
  end,
}
