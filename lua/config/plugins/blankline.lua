return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufEnter',
  init = function()
    local c = require('serenity.colors')
    vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { link = 'NeoTreeIndentMarker' })
    vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', { fg = c.accent })
  end,
  confit = function()
    require('indent_blankline').setup({
      -- show_current_context = true,
      show_current_context = true,
      show_current_context_start = true,
    })
  end,
}
