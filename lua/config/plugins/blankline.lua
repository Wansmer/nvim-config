return {
  'lukas-reineke/indent-blankline.nvim',
  enabled = true,
  event = 'BufReadPost',
  config = function()
    require('indent_blankline').setup({
      char = '',
      pace_char_blankline = ' ',
      show_current_context = true,
      show_current_context_start = false,
    })
  end,
}
