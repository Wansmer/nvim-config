return {
  'numToStr/Comment.nvim',
  enabled = true,
  event = { 'BufReadPre' },
  dependencies = {
    {
      'JoosepAlviste/nvim-ts-context-commentstring',
      dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },
  },
  config = function()
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })
  end,
}
