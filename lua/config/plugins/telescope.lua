return {
  'nvim-telescope/telescope.nvim',
  enabled = true,
  event = 'UIEnter',
  config = function()
    local telescope = require('telescope')

    local map = vim.keymap.set
    map('n', '<localleader>f', require('telescope.builtin').find_files, { desc = '' })
    map('n', '<localleader>g', require('telescope.builtin').live_grep, { desc = '' })
    map('n', '<localleader>b', require('telescope.builtin').buffers, { desc = '' })
    map('n', '<localleader>d', ':Telescope diagnostics<CR>', { desc = '' })
    map('n', '<localleader>o', require('telescope.builtin').oldfiles, { desc = '' })
    map('n', '<localleader>n', ':Telescope notify<CR>', { desc = '' })
    map('n', '<localleader><localleader>', require('telescope.builtin').current_buffer_fuzzy_find, { desc = '' })
    map('n', '<localleader>s', function()
      require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cword>') })
    end, { desc = '' })
    map('n', '<localleader>p', function()
      require('telescope.builtin').find_files({
        default_text = vim.fn.expand('<cword>'),
      })
    end, { desc = '' })
    telescope.setup({
      defaults = {
        -- For cool view with 'monokai-pro' scheme
        borderchars = PREF.ui.colorscheme == 'monokai-pro' and { '█', ' ', '▀', '█', '█', ' ', ' ', '▀' }
          or nil,
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
