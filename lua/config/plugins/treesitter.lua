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
    })
  end,
}
