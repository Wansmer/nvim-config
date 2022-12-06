local present, neotree = pcall(require, 'neo-tree')
if not present then
  return
end

local fs_commands = require('neo-tree/sources/filesystem/commands')

local function cd_or_open(state)
  local node = state.tree:get_node()
  if node.type ~= 'directory' then
    fs_commands.open_with_window_picker(state)
  end
  fs_commands.set_root(state)
end

local window_mappings = {
  ['l'] = 'open_with_window_picker',
  ['o'] = 'open_with_window_picker',
  ['sg'] = 'split_with_window_picker',
  ['sv'] = 'vsplit_with_window_picker',
  ['z'] = 'close_node',
  ['Z'] = 'close_all_nodes',
  ['N'] = { 'add', config = { show_path = 'relative' } },
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
    'buffers',
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
