local colorscheme = PREF.ui.colorscheme

local source = {
  tokyonight = 'tokyonight',
  catppuccin = 'catppuccin',
  kanagawa = 'kanagawa',
  nightfox = 'nightfox',
  dayfox = 'nightfox',
  dawnfox = 'nightfox',
  duskfox = 'nightfox',
  carbonfox = 'nightfox',
  nordfox = 'nightfox',
  terafox = 'nightfox',
  aquarium = 'aquarium',
  nightfly = 'nightfly',
  moonfly = 'moonfly',
  vscode = 'vscode',
  onedark = 'onedark',
  ['gruvbox-material'] = 'gruvbox-material',
}

pcall(require, 'config.colorscheme.' .. source[colorscheme])

local present, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)

if not present then
  vim.cmd([[colorscheme default]])
end
