return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = true,
  cmd = "Neotree",
  init = function()
    vim.keymap.set("n", "<Leader>e", "<Cmd>Neotree focus toggle<Cr>", { desc = "Open file explorer" })
    vim.keymap.set("x", "<Leader>e", "<Esc><Cmd>Neotree focus toggle<Cr>", { desc = "Open file explorer" })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    {
      "s1n7ax/nvim-window-picker",
      version = "v1.*",
      config = function()
        local picker = require("window-picker")

        local lm_ok, lm_utils = pcall(require, "langmapper.utils")
        if lm_ok then
          ---@diagnostic disable-next-line: duplicate-set-field
          require("window-picker.util").get_user_input_char = function()
            local char = vim.fn.getcharstr()
            return lm_utils.translate_keycode(char, "default", "ru")
          end
        end

        picker.setup({
          autoselect_one = true,
          include_current_win = false,
          show_prompt = false,
          filter_rules = {
            bo = {
              filetype = {
                "neo-tree",
                "neo-tree-popup",
                "notify",
                "quickfix",
                "qf",
                "toggleterm",
                "aerial",
              },
              buftype = { "terminal", "toggleterm" },
            },
          },
          other_win_hl_color = "#e35e4f",
        })
      end,
    },
  },
  config = function()
    local mappings = require("config.plugins.neo-tree.mappings")
    -- See: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/defaults.lua
    require("neo-tree").setup({
      sources = { "filesystem", "git_status" },
      add_blank_line_at_top = true,
      enable_modified_markers = true,
      popup_border_style = PREF.ui.border,

      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = { { source = "filesystem" }, { source = "git_status" } },
      },

      default_component_configs = {
        modified = { symbol = "" },

        git_status = {
          symbols = {
            deleted = "",
            renamed = "➜",
            untracked = "",
            ignored = "◌",
            unstaged = "󰜀",
            staged = "",
            conflict = "",
          },
        },
      },

      window = {
        width = 30,
        mappings = mappings.window,
      },

      filesystem = {
        window = {
          mappings = mappings.filesystem,
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { ".DS_Store", "node_modules" },
        },
        follow_current_file = { enabled = true },
      },

      git_status = {
        window = {
          mappings = mappings.git_status,
        },
      },
    })

    vim.api.nvim_create_autocmd({ "VimResume" }, {
      desc = "Update git_status in tree after fg",
      callback = function()
        require("neo-tree.sources.git_status").refresh()
      end,
    })

    vim.api.nvim_create_autocmd("FileType", {
      desc = "Remove statuscolumn for NeoTree window",
      pattern = "neo-tree",
      callback = function()
        vim.schedule(function()
          local winid = vim.api.nvim_get_current_win()
          if vim.wo[winid] ~= "" then
            vim.wo[winid].statuscolumn = ""
          end
        end)
      end,
    })
  end,
}
