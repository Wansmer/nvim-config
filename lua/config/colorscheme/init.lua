local colorscheme = PREF.ui.colorscheme

local source = {
  catppuccin = 'catppuccin', -- 5/5
  ['gruvbox-material'] = 'gruvbox-material', -- 4/5
  kanagawa = 'kanagawa',
  nightfox = 'nightfox',
  dayfox = 'nightfox',
  dawnfox = 'nightfox',
  duskfox = 'nightfox',
  carbonfox = 'nightfox',
  nordfox = 'nightfox',
  terafox = 'nightfox',
  onedark = 'onedark',
  ['rose-pine'] = 'rose-pine',
  tokyonight = 'tokyonight', -- 4/5
  vscode = 'vscode',
}

pcall(require, 'config.colorscheme.' .. source[colorscheme])
local present, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)

if not present then
  vim.cmd([[colorscheme default]])
end
