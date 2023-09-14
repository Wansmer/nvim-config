return {
  dir = '~/projects/code/personal/symbol-usage',
  dev = true,
  event = 'LspAttach',
  config = function()
    require('symbol-usage').setup()
  end
}
