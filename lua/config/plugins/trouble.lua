return {
  "folke/trouble.nvim",
  enabled = true,
  cmd = { "TroubleToggle", "Trouble" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({})

    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
      callback = function()
        vim.cmd([[Trouble qflist open]])
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "qf",
      callback = vim.schedule_wrap(function(e)
        vim.api.nvim_buf_delete(e.buf, { force = true })
      end),
    })
  end,
}
