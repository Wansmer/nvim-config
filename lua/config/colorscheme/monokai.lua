require('monokai-pro').setup({
  transparent_background = false,
  terminal_colors = true,
  devicons = false, -- highlight the icons of `nvim-web-devicons`
  styles = {
    comment = { italic = PREF.ui.italic_comment },
    keyword = { italic = false }, -- any other keyword
    type = { italic = false }, -- (preferred) int, long, char, etc
    storageclass = { italic = false }, -- static, register, volatile, etc
    structure = { italic = false }, -- struct, union, enum, etc
    parameter = { italic = false }, -- parameter pass in function
    annotation = { italic = false },
    tag_attribute = { italic = false }, -- attribute of tag in reactjs
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
    indent_blankline = {
      context_highlight = 'default', -- default | pro
      context_start_underline = false,
    },
  },
  ---@param c Colorscheme
  ---@diagnostic disable-next-line: unused-local
  override = function(c)
    return {
      FloatBorder = { link = 'NormalFloat' },
      TelescopePromptBorder = { bg = c.base.black, fg = c.base.black },
      TelescopePromptNormal = { bg = c.base.black },
      TelescopeResultsBorder = { bg = c.base.dimmed5, fg = c.base.dimmed5 },
      TelescopeResultsNormal = { bg = c.base.dimmed5 },
      TelescopePreviewBorder = { bg = c.base.dark, fg = c.base.dark },
      TelescopePreviewNormal = { bg = c.base.dark },
    }
  end,
})
