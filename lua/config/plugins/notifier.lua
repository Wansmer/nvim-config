return {
  'vigoux/notifier.nvim',
  event = 'VeryLazy',
  enabled = true,
  config = function()
    require('notifier').setup({
      -- You configuration here
    })
  end,
}
