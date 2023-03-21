local recursive = {
  split = {
    recursive = true,
    recursive_ignore = {
      'arguments',
      'parameters',
      'formal_parameters',
    },
  },
}

local langs = {
  javascript = {
    object = { split = recursive.split },
    array = { split = recursive.split },
    statement_block = { split = recursive.split },
  },
}

local opts = {
  use_default_keymaps = true,
  check_syntax_error = true,
  max_join_length = 1000,
  cursor_behavior = 'hold',
  notify = true,
  langs = langs,
  dot_repeat = true,
}

opts = PREF.dev_mode and {} or opts

return {
  'Wansmer/treesj',
  dir = '~/projects/code/personal/treesj',
  keys = { '<leader>m' },
  dev = true,
  enabled = true,
  config = function()
    local tsj = require('treesj')
    vim.keymap.set('n', '<leader>f', function()
      tsj.toggle({ split = { recursive = true } })
    end)
    tsj.setup(opts)
  end,
}
