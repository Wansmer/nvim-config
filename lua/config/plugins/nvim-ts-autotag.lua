return {
  'windwp/nvim-ts-autotag',
  event = 'BufReadPost',
  enabled = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('nvim-ts-autotag').setup()
  end
}
