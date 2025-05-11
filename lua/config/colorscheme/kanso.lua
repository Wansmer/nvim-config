local kanso = require("kanso")
require("kanso").setup({
  theme = "ink", -- zen, ink, pearl
  background = { -- map the value of 'background' option to a theme
    dark = "ink", -- try "ink" !
    light = "pearl",
  },
  overrides = function(c)
    return {
      NeoTreeNormal = { bg = c.theme.ui.bg_p1 },
      NeoTreeNormalNC = { bg = c.theme.ui.bg_p1 },

      -- {{ Telescope
      TelescopePromptBorder = { bg = c.theme.ui.bg_p1, fg = c.theme.ui.bg_p1 },
      TelescopePromptNormal = { bg = c.theme.ui.bg_p1 },
      TelescopePromptCounter = { link = "Special" },
      TelescopePromptTitle = { bg = c.palette.autumnYellow },
      TelescopeResultsTitle = { bold = true, bg = c.palette.autumnGreen },
      TelescopeResultsBorder = { bg = c.theme.ui.bg_p2, fg = c.theme.ui.bg_p2 },
      TelescopeResultsNormal = { bg = c.theme.ui.bg_p2 },
      -- TelescopeSelectionCaret = {},
      -- TelescopeMatching = {},
      TelescopePreviewBorder = { bg = c.palette.inkBlack0, fg = c.palette.inkBlack0 },
      TelescopePreviewNormal = { bg = c.palette.inkBlack0 },
      TelescopePreviewTitle = { bg = c.palette.lightBlue },
      -- }}
    }
  end,
})
