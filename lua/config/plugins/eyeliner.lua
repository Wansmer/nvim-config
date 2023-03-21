return {
  'jinh0/eyeliner.nvim',
  enable = true,
  config = function()
    require('eyeliner').setup({
      highlight_on_key = true,
      dim = false,
    })
  end,
}
