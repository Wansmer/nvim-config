return {
  'j-hui/fidget.nvim',
  event = 'LspAttach',
  enabled = true,
  config = function()
    require('fidget').setup()
  end,
}
