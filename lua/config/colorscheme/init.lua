local colorscheme = PREF.ui.colorscheme

local source = {
  catppuccin = 'catppuccin', -- 5/5
  tundra = 'tundra', -- 5/5
  kanagawa = 'kanagawa', -- 5/5
  tokyonight = 'tokyonight', -- 5/5
  ['gruvbox-material'] = 'gruvbox-material', -- 4/5
  vscode = 'vscode', -- 4/5
}

local config = source[colorscheme]

if config then
  pcall(require, 'config.colorscheme.' .. config)
end

local present, _ = pcall(vim.cmd.colorscheme, colorscheme)

if not present then
  vim.cmd.colorscheme('habamax')
end
