require('mellifluous').setup({
  dim_inactive = false,
  color_set = 'mountain', -- 'mellifluous', 'alduin', 'tender', 'mountain'
  styles = { -- see :h attr-list for options. set {} for NONE, { option = true } for option
    comments = { italic = true },
    conditionals = {},
    folds = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
  },
  transparent_background = {
    enabled = false,
    floating_windows = false,
    telescope = false,
    file_tree = false,
    cursor_line = false,
    status_line = false,
  },
  flat_background = {
    line_numbers = true,
    floating_windows = false,
    file_tree = false,
    cursor_line_number = true,
  },
  plugins = {
    cmp = true,
    gitsigns = true,
    indent_blankline = true,
    nvim_tree = {
      enabled = true,
      show_root = false,
    },
    neo_tree = {
      enabled = true,
    },
    telescope = {
      enabled = true,
      nvchad_like = true,
    },
    startify = true,
  },
})
