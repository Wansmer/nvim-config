return {
  'sustech-data/wildfire.nvim',
  enabled = true,
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('wildfire').setup()
  end,
}
