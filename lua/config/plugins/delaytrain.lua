return {
  'ja-ford/delaytrain.nvim',
  lazy = false,
  enabled = false,
  config = function()
    require('delaytrain').setup({
      ignore_filetypes = { 'neo-tree', 'alpha' },
    })
  end,
}
