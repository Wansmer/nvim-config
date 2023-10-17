local u = require('utils')
local fs_commands = require('neo-tree/sources/filesystem/commands')

local function cd_or_open(state)
  local node = state.tree:get_node()
  if node.type ~= 'directory' then
    -- TODO: check if no window is present
    fs_commands.open_with_window_picker(state)
  end
  fs_commands.set_root(state)
end

---Copy path of node under cursor to clipboard
---@param mode 'full'|'rel_home'|'rel_cwd'
---@return function
local function copy_patch_to_clipboard(mode)
  local modes = {
    full = function(path)
      return path
    end,
    rel_home = function(path)
      return vim.fn.fnamemodify(path, ':~')
    end,
    rel_cwd = function(path)
      return vim.fn.fnamemodify(path, ':.')
    end,
  }

  return function(state)
    local node = state.tree:get_node()
    local filepath = modes[mode](node:get_id())
    vim.fn.setreg('+', filepath)
  end
end

local function image_previes(state)
  local width = state.window.width + 1
  local node = state.tree:get_node()
  u.show_image(node:get_id(), { col = width })
end

return {
  window = {
    -- Override default mappings
    ['l'] = 'open_with_window_picker',
    ['o'] = 'open',
    ['<cr>'] = cd_or_open,
    ['<C-g>'] = 'split_with_window_picker',
    ['<C-v>'] = 'vsplit_with_window_picker',
    ['s'] = false,
    ['S'] = false,
    ['z'] = 'close_node',
    ['Z'] = 'close_all_nodes',
    ['?'] = false,
    ['g?'] = 'show_help',
    ['<S-TAB>'] = 'prev_source',
    ['<TAB>'] = 'next_source',
    ['a'] = 'add',
    ['Y'] = copy_patch_to_clipboard('full'),
    ['gY'] = copy_patch_to_clipboard('rel_home'),
    ['gy'] = copy_patch_to_clipboard('rel_cwd'),
    ['K'] = image_previes,

    -- Default window mappings
    -- ['<space>'] = {
    --   'toggle_node',
    --   nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
    -- },
    -- ['<2-LeftMouse>'] = 'open',
    -- ['<cr>'] = 'open',
    -- ['<esc>'] = 'cancel', -- close preview or floating neo-tree window
    -- ['P'] = { 'toggle_preview', config = { use_float = true } },
    -- ['l'] = 'focus_preview',
    -- ['S'] = 'open_split',
    -- -- ["S"] = "split_with_window_picker",
    -- ['s'] = 'open_vsplit',
    -- -- ["s"] = "vsplit_with_window_picker",
    -- ['t'] = 'open_tabnew',
    -- -- ["<cr>"] = "open_drop",
    -- -- ["t"] = "open_tab_drop",
    -- ['w'] = 'open_with_window_picker',
    -- ['C'] = 'close_node',
    -- ['z'] = 'close_all_nodes',
    -- --["Z"] = "expand_all_nodes",
    -- ['R'] = 'refresh',
    -- ['a'] = {
    --   'add',
    --   -- some commands may take optional config options, see `:h neo-tree-mappings` for details
    --   config = {
    --     show_path = 'none', -- "none", "relative", "absolute"
    --   },
    -- },
    -- ['A'] = 'add_directory', -- also accepts the config.show_path and config.insert_as options.
    -- ['d'] = 'delete',
    -- ['r'] = 'rename',
    -- ['y'] = 'copy_to_clipboard',
    -- ['x'] = 'cut_to_clipboard',
    -- ['p'] = 'paste_from_clipboard',
    -- ['c'] = 'copy', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
    -- ['m'] = 'move', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
    -- ['e'] = 'toggle_auto_expand_width',
    -- ['q'] = 'close_window',
    -- ['?'] = 'show_help',
    -- ['<'] = 'prev_source',
    -- ['>'] = 'next_source',
  },

  filesystem = {
    -- Override default mappings
    ['-'] = 'navigate_up',
    ['.'] = 'toggle_hidden',
    ['/'] = false,

    -- Default filesystem mappings
    -- ['H'] = 'toggle_hidden',
    -- ['/'] = 'fuzzy_finder',
    -- -- ['/'] = 'filter_as_you_type', -- this was the default until v1.28
    -- ['D'] = 'fuzzy_finder_directory',
    -- ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
    -- ["D"] = "fuzzy_sorter_directory",
    -- ['f'] = 'filter_on_submit',
    -- ['<C-x>'] = 'clear_filter',
    -- ['<bs>'] = 'navigate_up',
    -- ['.'] = 'set_root',
    -- ['[g'] = 'prev_git_modified',
    -- [']g'] = 'next_git_modified',
    -- ['i'] = 'show_file_details',
    -- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
    -- ['oc'] = { 'order_by_created', nowait = false },
    -- ['od'] = { 'order_by_diagnostics', nowait = false },
    -- ['og'] = { 'order_by_git_status', nowait = false },
    -- ['om'] = { 'order_by_modified', nowait = false },
    -- ['on'] = { 'order_by_name', nowait = false },
    -- ['os'] = { 'order_by_size', nowait = false },
    -- ['ot'] = { 'order_by_type', nowait = false },
  },
  fuzzy_finder = {
    -- Override default mappings
    -- TODO: why not working?
    -- ['<C-g>'] = 'split_with_window_picker',
    -- ['<C-v>'] = 'vsplit_with_window_picker',

    -- Default fuzzy finder mappings
    -- ['<down>'] = 'move_cursor_down',
    -- ['<C-n>'] = 'move_cursor_down',
    -- ['<up>'] = 'move_cursor_up',
    -- ['<C-p>'] = 'move_cursor_up',
  },

  git_status = {
    -- Default git status mappings
    -- ['A'] = 'git_add_all',
    -- ['gu'] = 'git_unstage_file',
    -- ['ga'] = 'git_add_file',
    -- ['gr'] = 'git_revert_file',
    -- ['gc'] = 'git_commit',
    -- ['gp'] = 'git_push',
    -- ['gg'] = 'git_commit_and_push',
    -- ['i'] = 'show_file_details',
    -- ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
    -- ['oc'] = { 'order_by_created', nowait = false },
    -- ['od'] = { 'order_by_diagnostics', nowait = false },
    -- ['om'] = { 'order_by_modified', nowait = false },
    -- ['on'] = { 'order_by_name', nowait = false },
    -- ['os'] = { 'order_by_size', nowait = false },
    -- ['ot'] = { 'order_by_type', nowait = false },
  },
}
