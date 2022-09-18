local present, configs = pcall(require, 'nvim-treesitter.configs')
if not present then
  return
end

configs.setup({
  ensure_installed = {
    'comment',
    'css',
    'dockerfile',
    'html',
    'javascript',
    'json',
    'lua',
    'make',
    'markdown',
    'regex',
    'scss',
    'tsx',
    'typescript',
    'yaml',
    'toml',
    'vue',
  },
  sync_install = false,
  ignore_install = { 'phpdoc' },
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = true,
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true },

  -- TREESITTER PLUGINS
  -- Autotag 'windwp/nvim-ts-autotag'
  autotag = {
    enable = true,
  },
  -- Rainbow 'windwp/nvim-ts-autotag'
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  -- playground
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
})
