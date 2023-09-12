return {
  'winston0410/range-highlight.nvim',
  event = { 'BufEnter' },
  dependencies = { 'winston0410/cmd-parser.nvim' },
  config = function()
    require('range-highlight').setup({})
  end,
}
