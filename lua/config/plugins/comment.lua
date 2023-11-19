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
    -- to skip backwards compatibility routines and speed up loading
    vim.g.skip_ts_context_commentstring_module = true
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })
  end,
}
