local DEV = true

return {
  "Wansmer/tfm.nvim",
  dir = DEV and "~/projects/code/personal/tfm.nvim" or nil,
  dev = DEV,
  enabled = true,
  event = "VeryLazy",
  config = function()
    require("tfm").setup({
      file_manager = "yazi",
      ui = {
        border = "double",
        height = 0.8,
        width = 0.8,
        x = 0.5,
        y = 0.5,
      },
    })
    vim.keymap.set("n", "<Leader>e", function()
      require("tfm").open()
    end)
  end,
}
