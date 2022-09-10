-- Настройки по умолчанию закомментированы
local theme_options = {
  tokyonight_style = 'night',
  -- tokyonight_italic_comments = true,
  -- tokyonight_italic_keywords = true,
  -- tokyonight_italic_functions = false,
  -- tokyonight_italic_variables = false,
  -- tokyonight_transparent = false,
  -- tokyonight_hide_inactive_statusline = false,
  tokyonight_sidebars = { 'packer', 'toggleterm' },
  -- tokyonight_transparent_sidebar = false,
  -- tokyonight_dark_sidebar = true,
  -- tokyonight_dark_float = true,
  -- tokyonight_colors = {},
  -- tokyonight_day_brightness = 0.3,
  tokyonight_lualine_bold = true,
}

for option, value in pairs(theme_options) do
  vim.g[option] = value
end
