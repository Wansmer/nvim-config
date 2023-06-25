PREF = {
  common = {
    textwidth = 120,
    tabwidth = 2,
    escape_keys = { 'jk', 'JK', 'jj' },
  },

  lsp = {
    format_on_save = true,
    virtual_text = false,
    show_signature_on_insert = false,
    show_diagnostic = true,
    -- Use take_over_mode for vue projects or not
    tom_enable = true,
  },

  ui = {
    -- (!) List of colorschemes lua/config/colorscheme/init.lua
    colorscheme = 'tokyonight',
    border = 'single',
    italic_comment = true,
  },

  git = {
    show_blame = false,
    show_signcolumn = true,
  },
}
