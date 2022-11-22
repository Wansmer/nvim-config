local ok, tsj = pcall(require, 'treesj')
if not ok then
  return
end

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
}

tsj.setup(opts)
