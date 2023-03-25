return {
  enabled = true,
  event = 'BufReadPost',
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
  end,
}
