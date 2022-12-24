return {
  'neovim/nvim-lspconfig',
  enabled = true,
  config = function()
    require('config.lsp')
  end,
}
