return {
  'jinh0/eyeliner.nvim',
  enable = true,
  keys = {
    { 'f', mode = 'n' },
    { 'f', mode = 'v' },
  },
  config = function()
    require('eyeliner').setup({
      highlight_on_key = true,
      dim = false,
    })
  end,
}
