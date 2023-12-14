return {
  'windwp/nvim-ts-autotag',
  event = 'BufEnter',
  enabled = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-ts-autotag').setup()
  end,
}
