require("kanagawa-paper").setup({
  undercurl = true,
  transparent = false,
  gutter = false,
  dimInactive = false, -- disabled when transparent
  terminalColors = true,
  commentStyle = { italic = true },
  functionStyle = { italic = false },
  keywordStyle = { italic = false, bold = false },
  statementStyle = { italic = false, bold = false },
  typeStyle = { italic = false },
  colors = { theme = {}, palette = {} }, -- override default palette and theme colors
  overrides = function(c) -- override highlight groups
    local nnc = { fg = c.theme.ui.float.fg, bg = c.theme.ui.float.bg }
    return {
      FloatBorder = { bg = nnc.bg, fg = nnc.bg },
      NeoTreeWinSeparator = { bg = nnc.bg, fg = nnc.bg, force = true },
      TelescopePromptBorder = { link = "FloatBorder" },
      TelescopePromptNormal = { link = "FloatBorder" },
      NeoTreeTabActive = { bg = c.theme.ui.bg_p1, fg = c.theme.ui.special },
    }
  end,
})
