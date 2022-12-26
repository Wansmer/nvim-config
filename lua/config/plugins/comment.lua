return {
  'numToStr/Comment.nvim',
  keys = {
    {
      'gc',
      mode = 'x',
    },
    'gcc',
    'gbc',
  },
  config = function()
    require('Comment').setup()
  end,
}
