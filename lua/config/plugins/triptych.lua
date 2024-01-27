return {
  "simonmclean/triptych.nvim",
  enabled = true,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "nvim-tree/nvim-web-devicons", -- optional
  },
  keys = { { "<leader>e", "<Cmd>Triptych<Cr>" } },
  config = function()
    require("triptych").setup({
      mappings = {
        -- Everything below is buffer-local, meaning it will only apply to Triptych windows
        show_help = "g?",
        nav_left = "h",
        nav_right = { "l", "<CR>" },
        delete = "d",
        add = "a",
        copy = "c",
        rename = "r",
        cut = "x",
        paste = "p",
        quit = "q",
        jump_to_cwd = "<Leader>.", -- Pressing again will toggle back
        toggle_hidden = ".",
      },
      options = {
        dirs_first = true,
        show_hidden = true,
        line_numbers = { enabled = false, relative = false },
        file_icons = {
          enabled = true,
          directory_icon = "",
          fallback_file_icon = "",
        },
        column_widths = { 0.25, 0.25, 0.5 }, -- Must add up to 1 after rounding to 2 decimal places
        highlights = { -- Highlight groups to use. See `:highlight` or `:h highlight`
          file_names = "NONE",
          directory_names = "NONE",
        },
        syntax_highlighting = { -- Applies to file previews
          enabled = true,
          debounce_ms = 100,
        },
      },
      git_signs = {
        enabled = false,
        signs = {
          add = "+",
          modify = "~",
          rename = "r",
          untracked = "?",
        },
      },
      diagnostic_signs = {
        enabled = true,
      },
      extension_mappings = {
        ["<C-g>"] = {
          mode = "n",
          fn = function(target)
            vim.cmd.Triptych()
            vim.schedule(function()
              vim.cmd.split(target.path)
            end)
          end,
        },
        ["<C-v>"] = {
          mode = "n",
          fn = function(target)
            vim.cmd.Triptych()
            vim.schedule(function()
              vim.cmd.vsplit(target.path)
            end)
          end,
        },
      },
    })
  end,
}
