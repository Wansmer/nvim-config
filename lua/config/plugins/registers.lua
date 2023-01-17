return {
  enabled = false,
  'tversteeg/registers.nvim',
  event = 'BufEnter',
  config = function()
    local registers = require('registers')

    registers.setup()
  end,
}
