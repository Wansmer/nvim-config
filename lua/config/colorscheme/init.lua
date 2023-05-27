local colorscheme = PREF.ui.colorscheme

-- Uses if one colorscheme could have different names but one config (e.g. nightfor, dayfox e.t.c)
local source = {
  catppuccin = 'catppuccin', -- 5/5
  tundra = 'tundra', -- 5/5
  kanagawa = 'kanagawa', -- 5/5
  tokyonight = 'tokyonight', -- 5/5
  ['gruvbox-material'] = 'gruvbox-material', -- 4/5
  vscode = 'vscode', -- 4/5
  everforest = 'everforest',
  mellifluous = 'mellifluous',
  ['monokai-pro'] = 'monokai',
}

local config = source[colorscheme]

if config then pcall(require, 'config.colorscheme.' .. config) end

local present, _ = pcall(vim.cmd.colorscheme, colorscheme)

if not present then vim.cmd.colorscheme('habamax') end

for _, type in pairs({ 'Error', 'Warn', 'Hint', 'Info' }) do
  local hl = 'DiagnosticUnderline' .. type
  local colors = vim.api.nvim_get_hl(0, { name = hl })
  vim.api.nvim_set_hl(0, hl, vim.tbl_extend('force', colors, { undercurl = true }))
end
