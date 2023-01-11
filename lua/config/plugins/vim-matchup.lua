return {
  'andymass/vim-matchup',
  event = 'BufReadPre',
  setup = function()
    -- vim.g.matchup_matchparen_offscreen = { method = 'popup' }
  end,
}
