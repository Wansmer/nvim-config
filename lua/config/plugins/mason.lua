return {
  'williamboman/mason.nvim',
  -- lazy = true,
  enabled = true,
  config = function()
    local mason = require('mason')
    mason.setup({
      ui = {
        border = PREF.ui.border,
      },
    })
  end,
}
