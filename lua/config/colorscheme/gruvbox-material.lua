vim.g.gruvbox_material_background = "hard" -- 'hard', 'medium', 'soft'
vim.g.gruvbox_material_disable_italic_comment = not PREF.ui.italic_comment
vim.g.gruvbox_material_enable_bold = true
vim.g.gruvbox_material_enable_italic = false
vim.g.gruvbox_material_cursor = "auto"
vim.g.gruvbox_material_transparent_background = 0

vim.schedule(function()
  local h = vim.api.nvim_set_hl
  local get_hl = function(name)
    return vim.api.nvim_get_hl(0, { name = name })
  end
  h(0, "WinBar", { link = "Normal" })
  h(0, "WinBarNC", { link = "Normal" })

  local nnc = get_hl("NeoTreeNormal")
  h(0, "NormalFloat", { link = "NeoTreeNormal" })
  h(0, "FloatBorder", { bg = nnc.bg, fg = nnc.bg })
  h(0, "NeoTreeWinSeparator", { bg = nnc.bg, fg = nnc.bg, force = true })

  -- {{ Telescope
  h(0, "TelescopePromptBorder", { link = "FloatBorder" })
  h(0, "TelescopePromptNormal", { bg = get_hl("FloatBorder").bg, fg = get_hl("Normal").fg })
  h(0, "TelescopePromptTitle", { bg = get_hl("Orange").fg, bold = true })

  h(0, "TelescopePreviewBorder", { link = "FloatBorder" })
  h(0, "TelescopePreviewNormal", { bg = get_hl("FloatBorder").bg })
  h(0, "TelescopePreviewTitle", { bg = get_hl("Green").fg, bold = true })

  local cc = get_hl("ColorColumn")
  h(0, "TelescopeResultsBorder", { bg = cc.bg, fg = cc.bg })
  h(0, "TelescopeResultsNormal", { bg = cc.bg })
  h(0, "TelescopeResultsTitle", { bg = get_hl("Blue").fg, bold = true })
  -- }}
end)
