return {
  'nvim-telescope/telescope.nvim',
  enabled = true,
  keys = {
    '<localleader>f',
    '<localleader>g',
    '<localleader>b',
    '<localleader>d',
    '<localleader>o',
    '<localleader>n',
    '<localleader>;',
    '<localleader>s',
  },
  cmd = 'Telescope',
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

    -- local map = vim.keymap.set
    local map = require('modules.mapper').map
    local builtin = require('telescope.builtin')

    map('n', '<localleader>f', builtin.find_files)
    map('n', '<localleader>g', builtin.live_grep)
    map('n', '<localleader>b', builtin.buffers)
    map('n', '<localleader>d', ':Telescope diagnostics<CR>')
    map('n', '<localleader>o', builtin.oldfiles)
    map('n', '<localleader>n', ':Telescope notify<CR>')
    map('n', '<localleader>;', builtin.current_buffer_fuzzy_find)
    map('n', '<localleader>s', function()
      builtin.live_grep({ default_text = vim.fn.expand('<cword>') })
    end)
    map('n', '<localleader>p', function()
      builtin.find_files({
        default_text = vim.fn.expand('<cword>'),
      })
    end)
  end,
}
