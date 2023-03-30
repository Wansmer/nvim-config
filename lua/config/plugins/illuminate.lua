return {
  'RRethy/vim-illuminate',
  event = 'BufReadPost',
  enabled = true,
  config = function()
    require('illuminate').configure({
      filetypes_denylist = { 'alpha', 'neo-tree', 'toggleterm' },
      min_count_to_highlight = 2,
    })
    vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'DiffAdd' })
    vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'DiffAdd' })
    vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'DiffAdd' })
  end,
}
