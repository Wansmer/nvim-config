return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'BufReadPre',
  enabled = true,
  config = function()
    require('treesitter-context').setup({ mode = 'cursor', max_lines = 3 })
  end,
}
