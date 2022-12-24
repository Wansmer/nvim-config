return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  event = 'BufReadPost',
  enabled = true,
  dependencies = {
    'p00f/nvim-ts-rainbow',
    'windwp/nvim-ts-autotag',
    'axelvc/template-string.nvim',
    'Wansmer/sibling-swap.nvim',
    {
      'nvim-treesitter/playground',
      cmd = 'TSPlaygroundToggle',
    },
    {
      'axelvc/template-string.nvim',
      enabled = true,
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
      config = function()
        local tstring = require('template-string')
        tstring.setup({
          filetypes = {
            'typescript',
            'javascript',
            'typescriptreact',
            'javascriptreact',
            'vue',
          },
          jsx_brackets = true,
          remove_template_string = false, -- remove backticks when there are no template string
          restore_quotes = {
            -- quotes used when "remove_template_string" option is enabled
            normal = [[']],
            jsx = [["]],
          },
        })
      end,
    },
  },
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

      -- Rainbow 'p00f/nvim-ts-rainbow'
      rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
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
