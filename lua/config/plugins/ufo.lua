return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'neovim/nvim-lspconfig',
    'kevinhwang91/promise-async',
  },
  config = function()
    require('ufo').setup({
      open_fold_hl_timeout = 0,
    })
  end,
}
