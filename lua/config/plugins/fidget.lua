return {
  'j-hui/fidget.nvim',
  enabled = true,
  config = function()
    local fidget = require('fidget')
    fidget.setup({
      spinner_rate = 125,
      fidget_decay = 10000,
      task_decay = 1000,
    })
  end,
}
