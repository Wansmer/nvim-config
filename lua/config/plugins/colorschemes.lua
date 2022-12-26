return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    enabled = PREF.ui.colorscheme == 'tokyonight',
  },
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    build = ':CatppuccinCompile',
    enabled = PREF.ui.colorscheme == 'catppuccin',
  },
  {
    'sam4llis/nvim-tundra',
    lazy = false,
    enabled = PREF.ui.colorscheme == 'tundra',
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    enabled = PREF.ui.colorscheme == 'gruvbox-material',
  },
}
