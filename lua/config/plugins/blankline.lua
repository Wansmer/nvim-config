return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufEnter',
  init = function ()
    vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { link = 'NeoTreeIndentMarker' })
  end,
  confit = function()
    require('indent_blankline').setup({
      show_current_context = true,
    })
  end,
}
