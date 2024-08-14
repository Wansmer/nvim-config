return {
  "folke/zen-mode.nvim",
  enabled = true,
  keys = {
    {
      "<leader>z",
      function()
        require("zen-mode").toggle({
          window = {
            width = vim.api.nvim_get_option_value("tw", { buf = 0 }),
          },
        })
      end,
    },
  },
  config = function()
    require("zen-mode").setup({
      on_open = function(win)
        local ft = vim.api.nvim_buf_get_option(0, "ft")
        -- For better writing
        if vim.tbl_contains({ "markdown", "text" }, ft) then
          for opt, val in pairs({ tw = 9999, linebreak = true, wrap = true }) do
            vim.opt_local[opt] = val
          end
        end
      end,
      on_close = function()
        local ft = vim.api.nvim_get_option_value("ft", { buf = 0 })
        -- restore original options
        if vim.tbl_contains({ "markdown", "text" }, ft) then
          for _, opt in ipairs({ "tw", "linebreak", "wrap" }) do
            vim.opt_local[opt] = vim.filetype.get_option(ft, opt)
          end
        end
      end,
    })
  end,
}
