local DEV = false

return {
  "Wansmer/tfm.nvim",
  dir = DEV and "~/projects/code/personal/tfm.nvim" or nil,
  dev = DEV,
  branch = "refactor",
  enabled = true,
  event = "VeryLazy",
  config = function()
    require("tfm").setup({
      file_manager = "yazi",
      follow_current_file = true,
      ui = {
        border = "double",
        height = 0.8,
        width = 0.8,
        x = 0.5,
        y = 0.5,
      },
      on_open = function(win, buf)
        vim.keymap.set("t", "q", "<Cmd>close<Cr>", { buffer = buf })
      end,
    })
    vim.keymap.set("n", "<leader>e", function()
      require("tfm").open()
    end)
  end,
}
