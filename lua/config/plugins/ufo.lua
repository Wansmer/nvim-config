return {
  'kevinhwang91/nvim-ufo',
  init = function()
    local map = vim.keymap.set
    map('n', 'zR', require('ufo').openAllFolds)
    map('n', 'zM', require('ufo').closeAllFolds)
  end,
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
