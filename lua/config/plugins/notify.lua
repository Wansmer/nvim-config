return {
  'rcarriga/nvim-notify',
  event = 'VeryLazy',
  enabled = true,
  config = function()
    local notify = require('notify')
    vim.notify = notify
  end,
}
