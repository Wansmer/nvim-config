return {
  'andymass/vim-matchup',
  event = 'BufReadPre',
  config = function()
    vim.g.matchup_matchparen_offscreen = { method = 'status' }
  end,
}
