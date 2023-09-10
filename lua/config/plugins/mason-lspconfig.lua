return {
  'williamboman/mason-lspconfig.nvim',
  enabled = true,
  lazy = true,
  dependencies = {
    'williamboman/mason.nvim',
    'neovim/nvim-lspconfig',
  },
  config = function()
    local mlsp = require('mason-lspconfig')
    mlsp.setup({
      ensure_installed = PREF.lsp.preinstall_servers,
      automatic_installation = true,
    })
  end,
}
