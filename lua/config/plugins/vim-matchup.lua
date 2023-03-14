return {
  'andymass/vim-matchup',
  event = 'BufReadPre',
  enable = true,
  config = function()
    vim.g.matchup_matchparen_offscreen = { method = 'status' }
  end,
}
