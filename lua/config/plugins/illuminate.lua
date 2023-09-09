return {
  'RRethy/vim-illuminate',
  event = 'BufReadPost',
  enabled = true,
  config = function()
    require('illuminate').configure({
      filetypes_denylist = { 'alpha', 'neo-tree', 'toggleterm' },
      min_count_to_highlight = 2,
    })
  end,
}
