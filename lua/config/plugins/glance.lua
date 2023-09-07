return {
  'dnlhc/glance.nvim',
  event = 'LspAttach',
  config = function()
    require('glance').setup({
      -- your configuration
    })
  end,
}
