return {
  'j-hui/fidget.nvim',
  event = 'LspAttach',
  enabled = false,
  config = function()
    require('fidget').setup()
  end,
}
