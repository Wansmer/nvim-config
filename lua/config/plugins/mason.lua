return {
  'williamboman/mason.nvim',
  enabled = true,
  event = 'UIEnter',
  config = function()
    require('mason').setup({
      ui = {
        border = PREF.ui.border,
      },
    })
  end,
}
