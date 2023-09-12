return {
  'nvim-treesitter/nvim-treesitter',
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  event = { 'BufReadPost', 'BufNewFile' },
  enabled = true,
  conkig = function()
    vim.keymap.set('n', 'tsp', '<Cmd>TSPlaygroundToggle<Cr>')
    vim.keymap.set('n', 'tsn', '<Cmd>TSNodeUnderCursor<Cr>')
    vim.keymap.set('n', 'tsh', '<Cmd>TSHighlightCapturesUnderCursor<Cr>')

    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = 'all',
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
