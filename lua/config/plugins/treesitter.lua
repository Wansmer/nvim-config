return {
  'nvim-treesitter/nvim-treesitter',
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  event = 'BufReadPost',
  enabled = true,
  config = function()
    local configs = require('nvim-treesitter.configs')
    configs.setup({
      ensure_installed = 'all',
      sync_install = false,
      ignore_install = { 'phpdoc' },
      highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
      },

      autopairs = {
        enable = true,
      },

      -- WARNING: Делает лишний отступ во vue
      indent = {
        enable = true,
      },

      -- TREESITTER PLUGINS
      -- Autotag 'windwp/nvim-ts-autotag'
      autotag = {
        enable = true,
      },

      matchup = {
        enable = true,
        disable = {},
      },

      -- playground
      playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
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
