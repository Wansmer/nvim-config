local present, neotree = pcall(require, 'neo-tree')
if not present then
  return
end

local fs_commands = require('neo-tree/sources/filesystem/commands')

local function cd_or_open(state)
  local node = state.tree:get_node()
  if node.type ~= 'directory' then
    -- TODO: check if no window is present
    fs_commands.open_with_window_picker(state)
  end
  fs_commands.set_root(state)
end

local function restart_lsp()
  local clients = vim.lsp.get_active_clients()
  if #clients then
    vim.cmd('LspRestart')
  end
end

local window_mappings = {
  ['l'] = 'open_with_window_picker',
  ['o'] = 'open',
  ['sg'] = 'split_with_window_picker',
  ['sv'] = 'vsplit_with_window_picker',
  ['s'] = false,
  ['z'] = 'close_node',
  ['Z'] = 'close_all_nodes',
  ['N'] = { 'add', config = { show_path = 'none' } },
  ['d'] = 'delete',
  ['r'] = 'rename',
  ['y'] = 'copy_to_clipboard',
  ['x'] = 'cut_to_clipboard',
  ['p'] = 'paste_from_clipboard',
  ['<leader>d'] = 'copy',
  ['m'] = 'move',
  ['q'] = 'close_window',
  ['R'] = 'refresh',
  ['?'] = 'show_help',
  ['<S-TAB>'] = 'prev_source',
  ['<TAB>'] = 'next_source',
}

local fs_mappings = {
  ['-'] = 'navigate_up',
  ['.'] = 'toggle_hidden',
  ['<cr>'] = cd_or_open,
  ['/'] = 'fuzzy_finder',
  ['D'] = 'fuzzy_finder_directory',
  ['f'] = 'filter_on_submit',
  ['<c-x>'] = 'clear_filter',
}

neotree.setup({
  sources = {
    'filesystem',
    'git_status',
    -- TODO: delete when plugin author answer on issue: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/643
    'buffers',
  },
  add_blank_line_at_top = true,
  popup_border_style = PREF.ui.border,

  event_handlers = {
    {
      event = 'file_added',
      handler = restart_lsp,
      id = 'optional unique id, only meaningful if you want to unsubscribe later',
    },
    {
      event = 'file_deleted',
      handler = restart_lsp,
      id = 'optional unique id, only meaningful if you want to unsubscribe later',
    },
    {
      event = 'file_moved',
      handler = restart_lsp,
      id = 'optional unique id, only meaningful if you want to unsubscribe later',
    },
    {
      event = 'file_renamed',
      handler = restart_lsp,
      id = 'optional unique id, only meaningful if you want to unsubscribe later',
    },
  },

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
    group_empty_dirs = true,
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
      buffers = nil,
      git_status = '  Git ',
    },
  },
})
