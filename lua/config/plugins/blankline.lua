return {
  'lukas-reineke/indent-blankline.nvim',
  enabled = true,
  event = 'BufReadPre',
  config = function()
    local ib = require('indent_blankline')

    ib.setup({
      char = '',
      pace_char_blankline = ' ',
      show_current_context = true,
      show_current_context_start = false,
    })
  end,
}
