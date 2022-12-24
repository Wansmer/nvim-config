return {
  { 'folke/tokyonight.nvim', lazy = false },
  {
    'catppuccin/nvim',
    lazy = false,
    name = 'catppuccin',
    build = ':CatppuccinCompile',
  },
  { 'sam4llis/nvim-tundra', lazy = false },
  { 'sainnhe/gruvbox-material', lazy = false },
  {
    'folke/neodev.nvim',
    config = function()
      require('neodev').setup()
    end,
    lazy = false,
  },
  'nvim-lua/plenary.nvim',
  'nvim-tree/nvim-web-devicons',
  'b0o/SchemaStore.nvim',
}
