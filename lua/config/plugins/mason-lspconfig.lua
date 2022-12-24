return {
  'williamboman/mason-lspconfig.nvim',
  enabled = true,
  config = function()
    local mlsp = require('mason-lspconfig')
    mlsp.setup({
      ensure_installed = PREF.lsp.preinstall_servers,
      automatic_installation = true,
    })
  end,
}
