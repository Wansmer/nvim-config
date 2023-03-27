return {
  'folke/zen-mode.nvim',
  keys = { { 'Z', ':ZenMode<CR>' } },
  config = function()
    require('zen-mode').setup()
  end,
}
