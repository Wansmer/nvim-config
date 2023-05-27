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
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    enabled = PREF.ui.colorscheme == 'vscode',
  },
  {
    'neanias/everforest-nvim',
    version = false,
    lazy = false,
    enabled = PREF.ui.colorscheme == 'everforest',
  },
  {
    'ramojus/mellifluous.nvim',
    dependencies = { 'rktjmp/lush.nvim' },
    enabled = PREF.ui.colorscheme == 'mellifluous',
  },
  {
    'loctvl842/monokai-pro.nvim',
    enabled = PREF.ui.colorscheme == 'monokai-pro',
  },
}
