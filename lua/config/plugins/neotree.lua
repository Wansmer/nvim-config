local present, neotree = pcall(require, 'neo-tree')
if not present then
  return
end

local fs_commands = require('neo-tree/sources/filesystem/commands')

local function cd_or_open(state)
  local node = state.tree:get_node()
  if node.type ~= 'directory' then
    fs_commands.open(state)
  end
  fs_commands.set_root(state)
end

-- По умолчанию: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/v2.x/lua/neo-tree/defaults.lua
neotree.setup({
  use_default_mappings = false,
  add_blank_line_at_top = true,
  close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
  popup_border_style = USER_SETTINGS.ui.border,
  enable_git_status = true,
  enable_diagnostics = USER_SETTINGS.lsp.show_diagnostic,
  default_component_configs = {
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on left hand side
      -- indent guides
      with_markers = true,
      indent_marker = '│',
      last_indent_marker = '└',
      highlight = 'NeoTreeIndentMarker',
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = '',
      expander_expanded = '',
      expander_highlight = 'NeoTreeExpander',
    },
    icon = {
      folder_closed = '',
      folder_open = '',
      folder_empty = '',
      -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
      -- then these will never be used.
      default = '*',
      highlight = 'NeoTreeFileIcon',
    },
    modified = {
      symbol = '',
      -- symbol = '[+]',
      highlight = 'NeoTreeModified',
    },
    name = {
      trailing_slash = false,
      use_git_status_colors = true,
      highlight = 'NeoTreeFileName',
    },
    git_status = {
      symbols = {
        added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
        modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
        -- deleted = '✖', -- this can only be used in the git_status source
        deleted = '', -- this can only be used in the git_status source
        renamed = '➜', -- this can only be used in the git_status source
        untracked = '',
        -- untracked = '★',
        ignored = '◌',
        unstaged = 'ﱴ',
        -- unstaged = '',
        staged = '',
        -- staged = '',
        conflict = '',
      },
    },
  },
  window = {
    position = 'left',
    width = 30,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      ['<cr>'] = function(state)
        cd_or_open(state)
      end,
      -- ['l'] = 'open',
      ['l'] = 'open_with_window_picker',
      ['o'] = 'open_with_window_picker',
      ['-'] = 'navigate_up',
      ['sg'] = 'open_split',
      ['sv'] = 'open_vsplit',
      -- ["S"] = "split_with_window_picker",
      -- ["s"] = "vsplit_with_window_picker",
      ['z'] = 'close_all_nodes',
      ['Z'] = 'expand_all_nodes',
      ['N'] = {
        'add',
        -- some commands may take optional config options, see `:h neo-tree-mappings` for details
        config = {
          show_path = 'none', -- "none", "relative", "absolute"
        },
      },
      ['d'] = 'delete',
      ['r'] = 'rename',
      ['y'] = 'copy_to_clipboard',
      ['x'] = 'cut_to_clipboard',
      ['p'] = 'paste_from_clipboard',
      ['c'] = 'copy', -- takes text input for destination, also accepts the optional config.show_path option like "add":
      ['m'] = 'move', -- takes text input for destination, also accepts the optional config.show_path option like "add".
      ['q'] = 'close_window',
      ['R'] = 'refresh',
      ['?'] = 'show_help',
      ['<'] = 'prev_source',
      ['>'] = 'next_source',
      ['.'] = 'toggle_hidden',
    },
  },
  nesting_rules = {},
  filesystem = {
    filtered_items = {
      visible = true, -- when true, they will just be displayed differently than normal items
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = true, -- only works on Windows for hidden files/directories
      hide_by_name = {
        --"node_modules"
      },
      hide_by_pattern = { -- uses glob style patterns
        --"*.meta",
        --"*/src/*/tsconfig.json",
      },
      always_show = { -- remains visible even if other settings would normally hide it
        --".gitignored",
      },
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        --".DS_Store",
        --"thumbs.db"
      },
    },
    follow_current_file = false, -- This will find and focus the file in the active buffer every
    -- time the current file is changed while the tree is open.
    group_empty_dirs = true, -- when true, empty folders will be grouped together
    hijack_netrw_behavior = 'open_default', -- netrw disabled, opening a directory opens neo-tree
    -- in whatever position is specified in window.position
    -- "open_current",  -- netrw disabled, opening a directory opens within the
    -- window like netrw would, regardless of window.position
    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
    use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
    -- instead of relying on nvim autocmd events.
    -- window = {
    --   mappings = {
    --     ['<bs>'] = 'navigate_up',
    --     -- ['.'] = 'set_root',
    --     ['.'] = 'toggle_hidden',
    --     ['/'] = 'fuzzy_finder',
    --     ['D'] = 'fuzzy_finder_directory',
    --     ['f'] = 'filter_on_submit',
    --     ['<c-x>'] = 'clear_filter',
    --     ['[g'] = 'prev_git_modified',
    --     [']g'] = 'next_git_modified',
    --   },
    -- },
  },
  renderers = {
    directory = {
      { 'indent' },
      { 'icon' },
      { 'current_filter' },
      {
        'container',
        content = {
          { 'name', zindex = 10 },
          { 'clipboard', zindex = 10 },
          { 'diagnostics', errors_only = true, zindex = 20, align = 'right' },
          { 'git_status', zindex = 20, align = 'right' },
        },
      },
    },
  },
})
