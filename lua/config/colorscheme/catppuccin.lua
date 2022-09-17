vim.g.catppuccin_flavour = 'mocha' -- latte, frappe, macchiato, mocha
local mocha = require('catppuccin.palettes').get_palette('mocha')

require('catppuccin').setup({
  dim_inactive = {
    enabled = true,
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
    comments = { 'italic' },
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
    coc_nvim = false,
    lsp_trouble = false,
    cmp = true,
    lsp_saga = false,
    gitgutter = false,
    gitsigns = true,
    leap = false,
    telescope = true,
    nvimtree = {
      enabled = true,
      show_root = true,
      transparent_panel = false,
    },
    neotree = {
      enabled = true,
      show_root = true,
      transparent_panel = false,
    },
    dap = {
      enabled = false,
      enable_ui = false,
    },
    which_key = false,
    indent_blankline = {
      enabled = true,
      colored_indent_levels = false,
    },
    dashboard = false,
    neogit = false,
    vim_sneak = false,
    fern = false,
    barbar = false,
    bufferline = true,
    markdown = true,
    lightspeed = false,
    ts_rainbow = true,
    hop = false,
    notify = true,
    telekasten = false,
    symbols_outline = false,
    mini = false,
    aerial = false,
    vimwiki = true,
    beacon = false,
    navic = true,
    overseer = false,
  },
  color_overrides = {},
  highlight_overrides = {
    mocha = {
      GitSignsAdd = { bg = mocha.base },
      GitSignsChange = { bg = mocha.base },
      GitSignsDelete = { bg = mocha.base },
    },
  },
})
