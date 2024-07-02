return {
  "nvim-telescope/telescope.nvim",
  enabled = true,
  event = "VeryLazy",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
  },
  config = function()
    local telescope = require("telescope")
    local pickers = require("telescope.builtin")

    local map = vim.keymap.set
    -- Builtins pickers
    map("n", "<localleader>f", pickers.find_files, { desc = "Telescope: Find files in (cwd>" })
    -- map("n", "<localleader>g", pickers.live_grep, { desc = "Telescope: live grep <cwd>" })
    map(
      "n",
      "<localleader>g",
      telescope.extensions.live_grep_args.live_grep_args,
      { desc = "Telescope: live grep with args" }
    )
    map("n", "<localleader>b", pickers.buffers, { desc = "Telescope: show open buffers" })
    -- map('n', '<localleader>d', pickers.diagnostics, { desc = 'Telescope: show diagnostics' })
    map("n", "<localleader>o", pickers.oldfiles, { desc = "Telescope: show recent using files" })
    map("n", "<localleader><localleader>", function()
      pickers.current_buffer_fuzzy_find({ default_text = vim.fn.expand("<cword>") })
    end, { desc = "Telescope: fuzzy find word under cursor in current buffer" })
    map("n", "<localleader>w", function()
      pickers.live_grep({ default_text = vim.fn.expand("<cword>") })
    end, { desc = "Telescope: live grep word under cursor (cwd>" })
    map("n", "<localleader>p", function()
      pickers.find_files({ default_text = vim.fn.expand("<cword>") })
    end, { desc = "Telescope: find file under cursor (cwd)" })
    map("n", "<localleader>T", function()
      pickers.builtin({ include_extensions = true })
    end)

    -- Plugin's pickers
    map("n", "<localleader>n", ":Telescope notify<CR>", { desc = "Telescope: show notifications" })

    -- WARNING: now works only with 'cwd' pickers, because no need know bufnr
    local switch_picker = function(picker_name)
      return function(prompt_bufnr)
        local cur_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
        local text = cur_picker:_get_prompt()
        pickers[picker_name]({
          default_text = text,
        })
      end
    end

    local actions = require("telescope.actions")
    local lga_actions = require("telescope-live-grep-args.actions")
    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "bottom",
          vertical = {
            width = 0.8,
            height = 0.8,
          },
        },
        file_ignore_patterns = { ".git/", "node_modules/*" },
        mappings = {
          i = {
            ["<C-2>"] = switch_picker("live_grep"),
            ["<C-3>"] = switch_picker("find_files"),
            ["<C-g>"] = actions.select_horizontal,
            ["<C-u>"] = false, -- Clear instead of preview scroll up
            ["<S-Cr>"] = function(prompt_bufnr)
              -- Use nvim-window-picker to choose the window by dynamically attaching a function
              local action_set = require("telescope.actions.set")
              local action_state = require("telescope.actions.state")

              local cur_picker = action_state.get_current_picker(prompt_bufnr)
              cur_picker.get_selection_window = function(picker, _)
                local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
                -- Unbind after using so next instance of the picker acts normally
                picker.get_selection_window = nil
                return picked_window_id
              end

              return action_set.edit(prompt_bufnr, "edit")
            end,
            ["<C-f>"] = function()
              vim.api.nvim_feedkeys(vim.keycode("<Right>"), "n", true)
            end,
            ["<C-b>"] = function()
              vim.api.nvim_feedkeys(vim.keycode("<Left>"), "n", true)
            end,
          },
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              -- freeze the current list and start a fuzzy search in the frozen list
              ["<C-j>"] = actions.to_fuzzy_refine,
            },
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")
  end,
}
