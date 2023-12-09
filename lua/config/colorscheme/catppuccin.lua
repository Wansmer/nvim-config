vim.g.catppuccin_flavour = 'macchiato' -- latte, frappe, macchiato, mocha
local mocha = require('catppuccin.palettes').get_palette('mocha')

require('catppuccin').setup({
  dim_inactive = {
    enabled = false,
    shade = 'dark',
    percentage = 0.15,
  },
  transparent_background = false,
  term_colors = false,
  compile = {
    enabled = true,
    path = vim.fn.stdpath('cache') .. '/catppuccin',
  },
  styles = {
    comments = PREF.ui.italic_comment and { 'italic' } or {},
    conditionals = { 'italic' },
    loops = { 'italic' },
    functions = { 'bold' },
    keywords = { 'italic' },
    strings = {},
    variables = {},
    numbers = { 'bold' },
    booleans = { 'bold' },
    properties = {},
    types = {},
    operators = {},
  },
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = {},
        hints = {},
        warnings = {},
        information = {},
      },
      underlines = {
        errors = { 'underline' },
        hints = { 'underline' },
        warnings = { 'underline' },
        information = { 'underline' },
      },
    },
    cmp = true,
    gitsigns = true,
    telescope = true,
    neotree = true,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    bufferline = true,
    markdown = true,
    notify = true,
    aerial = true,
    vimwiki = true,
  },
  color_overrides = {},
  highlight_overrides = {
    all = function(colors)
      return {
        WinBarNC = { link = 'WinBar' },
        NeoTreeWinSeparator = { fg = colors.base, bg = colors.base },
        IblScope = { fg = colors.surface2 },
      }
    end,
  },
})
