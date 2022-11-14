local present, colorizer = pcall(require, 'colorizer')

if not present then
  return
end

colorizer.setup({
  filetypes = { 'html', 'vue', 'css', 'scss' },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = false, -- "Name" codes like Blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    sass = {
      enable = true,
      parsers = { 'css' },
    },
    mode = 'virtualtext', -- Set the display mode.
    virtualtext = '',
  },
})
