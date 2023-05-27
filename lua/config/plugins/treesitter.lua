return {
  'nvim-treesitter/nvim-treesitter',
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  event = { 'BufReadPost', 'BufNewFile' },
  enabled = true,
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = {
        'bash',
        'c',
        'cmake',
        'cpp',
        'css',
        'diff',
        'dockerfile',
        'gitignore',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'json5',
        'jsonc',
        'lua',
        'luadoc',
        'luap',
        'make',
        'markdown',
        'markdown_inline',
        'query',
        'regex',
        'scss',
        'sql',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'vue',
        'yaml',
        'dart',
        'rust',
      },
      sync_install = false,
      ignore_install = { 'phpdoc', 'comment' },
      highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
      },

      -- WARNING: Делает лишний отступ во vue
      indent = {
        enable = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn', -- set to `false` to disable one of the mappings
          node_incremental = ',',
          scope_incremental = 'grc',
          node_decremental = '.',
        },
      },

      query_linter = {
        enable = true,
        use_virtual_text = false,
        lint_events = { 'BufWrite', 'CursorHold' },
      },

      -- TREESITTER PLUGINS
      autotag = {
        enable = true,
      },

      autopairs = {
        enable = true,
      },

      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },

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
  end,
}
