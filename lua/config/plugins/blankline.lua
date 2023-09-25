return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufEnter',
  enabled = true,
  config = function()
    require('indent_blankline').setup({
      show_current_context = true,
      char = '▏',
      context_char = '▏',
      show_current_context_start = false,
    })
  end,
}
