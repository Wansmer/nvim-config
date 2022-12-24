return {
  'jayp0521/mason-null-ls.nvim',
  enabled = true,
  config = function()
    local mnls = require('mason-null-ls')
    mnls.setup({
      automatic_installation = true,
    })
  end,
}
