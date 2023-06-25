require('tokyonight').setup({
  style = 'storm', -- night, moon, storm
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = { italic = PREF.ui.italic_comment },
    keywords = { italic = true },
    functions = {},
    variables = {},
    sidebars = 'dark',
    floats = 'dark',
  },
  sidebars = { 'qf', 'help' },
  dim_inactive = true,
})
