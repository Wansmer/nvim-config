return {
  'nvim-telescope/telescope.nvim',
  enabled = true,
  event = 'VeryLazy',
  config = function()
    local telescope = require('telescope')

    telescope.load_extension('notify')

    telescope.setup({
      defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
        path_display = { 'smart' },
        layout_strategy = 'horizontal',
        layout_config = {
          prompt_position = 'top',
        },
        file_ignore_patterns = {
          '.git/',
          'node_modules/*',
        },
      },
    })
  end,
}
