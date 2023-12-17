return {
  "akinsho/toggleterm.nvim",
  enabled = true,
  keys = { "<C-;>" },
  config = function()
    local toggleterm = require("toggleterm")
    vim.keymap.set("t", "<C-d>", "<C-c>exit<Cr>")

    toggleterm.setup({
      size = 20,
      open_mapping = [[<C-;>]],
      hide_numbers = true,
      shade_filetypes = {},
      start_in_insert = true,
      insert_mappings = true,
      persist_size = false,
      persist_mode = false,
      direction = "float", -- 'float', 'horizontal', 'vertical', 'tab'
      close_on_exit = true,
      shell = vim.o.shell,
      -- highlights = {}, -- Not working
      float_opts = {
        border = { "", "", "", " ", " ", " ", " ", " " },
        relative = "editor",
        width = vim.opt.columns:get(),
        height = 20,
        col = 0,
        row = vim.opt.lines:get(),
        style = "minimal",
        title = "Hello KITTY",
        title_pos = "left",
        noautocmd = true,
      },
      on_open = function(term)
        local map = vim.keymap.set

        map({ "t", "i", "n" }, "<C-=>", function()
          local win_opts = vim.api.nvim_win_get_config(term.window)
          if win_opts.height <= vim.opt.lines:get() - 5 then
            win_opts.height = win_opts.height + 5
            vim.api.nvim_win_set_config(term.window, win_opts)
          end
        end, { buffer = term.buf })

        map({ "t", "i", "n" }, "<C-->", function()
          local win_opts = vim.api.nvim_win_get_config(term.window)
          if win_opts.height > 5 then
            win_opts.height = win_opts.height - 5
            vim.api.nvim_win_set_config(term.window, win_opts)
          end
        end, { buffer = term.buf })

        local ns = vim.api.nvim_create_namespace("__ToggleTerm")
        vim.api.nvim_set_hl(ns, "Normal", { bg = "#000000" })
        vim.api.nvim_set_hl(ns, "FloatBorder", { bg = "#000000", fg = "#000000" })
        vim.api.nvim_win_set_hl_ns(term.window, ns)
      end,
    })
  end,
}
