return {
  'sustech-data/wildfire.nvim',
  enabled = false,
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('wildfire').setup()
  end,
}
