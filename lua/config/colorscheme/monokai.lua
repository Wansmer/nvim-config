require('monokai-pro').setup({
  transparent_background = false,
  terminal_colors = true,
  devicons = true, -- highlight the icons of `nvim-web-devicons`
  styles = {
    comment = { italic = PREF.ui.italic_comment },
    keyword = { italic = true }, -- any other keyword
    type = { italic = true }, -- (preferred) int, long, char, etc
    storageclass = { italic = true }, -- static, register, volatile, etc
    structure = { italic = true }, -- struct, union, enum, etc
    parameter = { italic = true }, -- parameter pass in function
    annotation = { italic = true },
    tag_attribute = { italic = true }, -- attribute of tag in reactjs
  },
  filter = 'octagon', -- classic | octagon | pro | machine | ristretto | spectrum
  -- Enable this will disable filter option
  day_night = {
    enable = false, -- turn off by default
    day_filter = 'octagon', -- classic | octagon | pro | machine | ristretto | spectrum
    night_filter = 'octagon', -- classic | octagon | pro | machine | ristretto | spectrum
  },
  inc_search = 'background', -- underline | background
  background_clear = {}, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree"
  plugins = {
    bufferline = {
      underline_selected = false,
      underline_visible = false,
    },
    -- indent_blankline = {
    --   context_highlight = 'default', -- default | pro
    --   context_start_underline = false,
    -- },
  },
  ---@param c Colorscheme
  ---@diagnostic disable-next-line: unused-local
  override = function(c) end,
})
