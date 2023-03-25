return {
  'nvim-neo-tree/neo-tree.nvim',
  enabled = true,
  keys = {
    {
      '<Localleader>e',
      '<Cmd>Neotree focus toggle<Cr>',
      desc = 'Open file explorer',
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      version = 'v1.*',
      config = function()
        require('window-picker').setup({
          autoselect_one = true,
          include_current_win = false,
          show_prompt = false,
          filter_rules = {
            bo = {
              filetype = {
                'neo-tree',
                'neo-tree-popup',
                'notify',
                'quickfix',
                'qf',
                'toggleterm',
              },
              buftype = { 'terminal', 'toggleterm' },
            },
          },
          other_win_hl_color = '#e35e4f',
        })
      end,
    },
  },
  config = function()
    local neotree = require('neo-tree')
    local fs_commands = require('neo-tree/sources/filesystem/commands')
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    local function cd_or_open(state)
      local node = state.tree:get_node()
      if node.type ~= 'directory' then
        -- TODO: check if no window is present
        fs_commands.open_with_window_picker(state)
      end
      fs_commands.set_root(state)
    end

    local window_mappings = {
      ['o'] = 'open',
      ['l'] = 'open_with_window_picker',
      ['sg'] = 'split_with_window_picker',
      ['sv'] = 'vsplit_with_window_picker',
      ['s'] = false,
      ['z'] = 'close_node',
      ['Z'] = 'close_all_nodes',
      ['N'] = 'add',
      ['d'] = 'delete',
      ['r'] = 'rename',
      ['y'] = 'copy_to_clipboard',
      ['x'] = 'cut_to_clipboard',
      ['p'] = 'paste_from_clipboard',
      ['<leader>d'] = 'copy',
      ['m'] = 'move',
      ['q'] = 'close_window',
      ['R'] = 'refresh',
      ['g?'] = 'show_help',
      ['?'] = false,
      ['<S-TAB>'] = 'prev_source',
      ['<TAB>'] = 'next_source',
    }

    local fs_mappings = {
      ['-'] = 'navigate_up',
      ['.'] = 'toggle_hidden',
      ['<cr>'] = cd_or_open,
      ['D'] = 'fuzzy_finder_directory',
      ['f'] = 'filter_on_submit',
      ['<c-x>'] = 'clear_filter',
      -- Use '/' for regular search
      ['/'] = false,
    }

    neotree.setup({
      sources = {
        'filesystem',
        'git_status',
      },
      add_blank_line_at_top = true,
      popup_border_style = PREF.ui.border,

      default_component_configs = {
        modified = {
          symbol = '',
          highlight = 'NeoTreeModified',
        },
        git_status = {
          symbols = {
            deleted = '',
            renamed = '➜',
            untracked = '',
            ignored = '◌',
            unstaged = 'ﱴ',
            staged = '',
            conflict = '',
          },
        },
      },

      window = {
        width = 30,
        mappings = window_mappings,
      },

      filesystem = {
        bind_to_cwd = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { '.DS_Store', 'node_modules' },
        },
        follow_current_file = true,
        group_empty_dirs = false,
        use_libuv_file_watcher = true,
        window = {
          mappings = fs_mappings,
        },
      },

      git_status = {
        window = {
          position = 'float',
          mappings = {
            ['A'] = 'git_add_all',
            ['gu'] = 'git_unstage_file',
            ['ga'] = 'git_add_file',
            ['gr'] = 'git_revert_file',
            ['gc'] = 'git_commit',
            ['gp'] = 'git_push',
            ['gg'] = 'git_commit_and_push',
          },
        },
      },

      source_selector = {
        winbar = true,
        content_layout = 'center',
        tab_labels = {
          filesystem = '  Project ',
          git_status = '  Git ',
          buffers = nil,
        },
      },
    })
  end,
}
