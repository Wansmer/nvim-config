return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = true,
  cmd = "Neotree",
  cond = not vim.g.vscode,
  init = function()
    vim.keymap.set("n", "<LocalLeader>e", "<Cmd>Neotree focus toggle<Cr>", { desc = "Open file explorer" })
    vim.keymap.set("n", "<LocalLeader>E", "<Cmd>Neotree focus<Cr>", { desc = "Open file explorer" })
    vim.keymap.set("x", "<LocalLeader>e", "<Esc><Cmd>Neotree focus toggle<Cr>", { desc = "Open file explorer" })
  end,
  -- deactivate = function()
  --   vim.cmd([[Neotree close]])
  -- end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- "saifulapm/neotree-file-nesting-config",
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

    ---Get custom sort function for js/ts projects according fsd folders order
    ---@return function|nil
    local function get_custom_sort_function()
      -- checks if package.json exists in current directory
      local is_js_project = vim.uv.fs_stat("package.json")
      if is_js_project then
        -- Default sort function from neo-tree source
        local function sort_items(a, b)
          if a.type == b.type then
            return a.path < b.path
          else
            return a.type < b.type
          end
        end

        -- Sort order in fsd methodology
        local fsd_order = { app = 1, pages = 2, widgets = 3, features = 4, entities = 5, shared = 6 }
        return function(a, b)
          if fsd_order[a.name] and fsd_order[b.name] then
            return fsd_order[a.name] < fsd_order[b.name]
          end
          return sort_items(a, b)
        end
      else
        return nil
      end
    end

    local ok_nest, nesting = pcall(require, "neotree-file-nesting-config")

    -- See: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/defaults.lua
    require("neo-tree").setup({
      nesting_rules = ok_nest and nesting.nesting_rules,
      sources = { "filesystem", "git_status" },
      add_blank_line_at_top = true,
      enable_modified_markers = true,
      popup_border_style = PREF.ui.border,
      sort_function = get_custom_sort_function(),

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
            staged = "󰄴",
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

    vim.api.nvim_create_autocmd({ "VimResume", "FocusGained", "TermLeave" }, {
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

    vim.api.nvim_create_autocmd("User", {
      desc = "Close NeoTree on exit before session is saved",
      pattern = "PersistenceSavePre",
      callback = function()
        vim.cmd([[Neotree close]])
      end,
    })
  end,
}
