return {
  'numToStr/Comment.nvim',
  keys = { 'gc', 'gcc', 'gbc' },
  config = function()
    require('Comment').setup()
  end,
}
