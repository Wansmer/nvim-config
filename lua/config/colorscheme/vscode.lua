-- vim.o.background = 'dark'
-- vim.o.background = 'light'

-- local c = require('vscode.colors')
require('vscode').setup({
  -- Enable transparent background
  transparent = false,

  -- Enable italic comment
  italic_comments = PREF.ui.italic_comment,

  -- Disable nvim-tree background color
  disable_nvimtree_bg = true,

  -- Override colors (see ./lua/vscode/colors.lua)
  color_overrides = {
    -- vscLineNumber = '#FFFFFF',
  },

  -- Override highlight groups (see ./lua/vscode/theme.lua)
  group_overrides = {
    -- this supports the same val table as vim.api.nvim_set_hl
    -- use colors from this colorscheme by requiring vscode.colors!
    -- Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
  },
})
