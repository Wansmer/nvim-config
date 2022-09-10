local present, nvim_tree = pcall(require, 'nvim-tree')
if not present then
  return
end

local map = vim.keymap.set
local nvim_tree_config = require('nvim-tree.config')
local tree_cb = nvim_tree_config.nvim_tree_callback
local api = require('nvim-tree.api')

local function cd_or_open(node)
  if node.type == 'directory' then
    api.tree.change_root_to_node()
  else
    api.node.open.edit()
  end
end

local function resize(operator)
  return function()
    vim.cmd('NvimTreeResize ' .. operator .. '5')
  end
end

nvim_tree.setup({
  -- Открыть nvim-tree при открытии директории
  open_on_setup = false,
  -- Открывать nvim-tree при открытии файла
  open_on_setup_file = false,
  -- Без этой опции не откроется, если использовать alpha
  ignore_buffer_on_setup = false,
  -- Отключение встроенного netrw.
  -- WARNING: Если true, то gx (переход по ссылке под курсором) не будет работать
  disable_netrw = false,
  hijack_unnamed_buffer_when_opening = true,
  hijack_netrw = true,
  auto_reload_on_write = true,
  -- Новый файл внутри директории под курсором
  create_in_closed_folder = true,
  open_on_tab = false,
  sort_by = 'name', -- 'name', 'case_sensitive', 'modification_time', 'extension'.
  -- Курсор всегда на первой букве файла/директории(true) или в начале строки(false)
  hijack_cursor = false,
  update_cwd = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = '',
      info = '',
      warning = '',
      error = '',
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = { 'help' },
  },
  git = {
    enable = true,
    -- Отображать или не отображать файлы, записанные в .gitignore
    ignore = false,
    timeout = 500,
  },
  on_attach = function(bufnr)
    local inject_node = require('nvim-tree.utils').inject_node
    local opts = { buffer = bufnr, noremap = true }
    map('n', '<CR>', inject_node(cd_or_open), opts)
    map('n', 'l', tree_cb('edit'), opts)
    map('n', 'o', tree_cb('edit'), opts)
    map('n', 'sv', tree_cb('vsplit'), opts)
    map('n', 'sg', tree_cb('split'), opts)
    map('n', '<S-n>', tree_cb('create'), opts)
    map('n', '?', tree_cb('toggle_help'), opts)
    map('n', '.', tree_cb('toggle_hidden'), opts)
    map('n', '<', resize('-'), opts)
    map('n', '>', resize('+'), opts)
  end,
  renderer = {
    group_empty = true,
    add_trailing = false,
    full_name = true,
    highlight_git = false,
    highlight_opened_files = 'none',
    root_folder_modifier = ':~',
    indent_markers = {
      enable = true,
      icons = {
        corner = '└',
        edge = '│ ',
        none = '  ',
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = 'before',
      padding = ' ',
      symlink_arrow = ' ➛ ',
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = false,
      },
      glyphs = {
        default = '',
        symlink = '',
        git = {
          unstaged = '',
          staged = '✓',
          unmerged = '',
          renamed = '➜',
          untracked = '★',
          deleted = '',
          ignored = '◌',
        },
        folder = {
          default = '',
          open = '',
          empty = '',
          empty_open = '',
          symlink = '',
        },
      },
    },
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    -- mappings = {
    --   custom_only = false,
    --   list = {
    --     { key = { 'l', '<CR>', 'o' }, cb = tree_cb('edit') },
    --     { key = 'h', cb = tree_cb('close_node') },
    --     { key = 'sv', cb = tree_cb('vsplit') },
    --     { key = 'sg', cb = tree_cb('split') },
    --     { key = '<S-n>', cb = tree_cb('create') },
    --     { key = '?', cb = tree_cb('toggle_help') },
    --     { key = '>', cb = "<CMD>exec ':NvimTreeResize +5'<CR>" },
    --     { key = '<', cb = "<CMD>exec ':NvimTreeResize -5'<CR>" },
    --     { key = '.', cb = tree_cb('toggle_dotfiles') },
    --   },
    -- },
    number = false,
    relativenumber = false,
  },
})
