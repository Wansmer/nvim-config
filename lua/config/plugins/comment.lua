return {
  enabled = true,
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
  end,
}
