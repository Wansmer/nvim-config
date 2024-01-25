vim.g.gruvbox_material_background = "hard" -- 'hard', 'medium', 'soft'
vim.g.gruvbox_material_disable_italic_comment = not PREF.ui.italic_comment
vim.g.gruvbox_material_enable_bold = true
vim.g.gruvbox_material_enable_italic = false
vim.g.gruvbox_material_cursor = "auto"
vim.g.gruvbox_material_transparent_background = 0

vim.schedule(function()
  vim.api.nvim_set_hl(0, "WinBar", { link = "Normal" })
  vim.api.nvim_set_hl(0, "WinBarNC", { link = "Normal" })
end)
