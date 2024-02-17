return {
  "akinsho/bufferline.nvim",
  enabled = true,
  version = "*",
  event = "VeryLazy",
  config = function()
    vim.api.nvim_win_get_position(0)
    vim.api.nvim_win_get_config(0)
    vim.api.nvim_tabpage_list_wins(0)
    require("bufferline").setup({
      options = {
        diagnostics = false,
        offsets = {
          { filetype = "neo-tree", text = "File Explorer" },
          { filetype = "aerial", text = "Document Symbols" },
        },
      },
    })
  end,
}
