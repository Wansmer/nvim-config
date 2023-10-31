return {
  'akinsho/bufferline.nvim',
  enabled = true,
  version = '*',
  event = 'VeryLazy',
  config = function()
    require('bufferline').setup({
      options = {
        diagnostics = false,
        offsets = { { filetype = 'neo-tree', text = 'File Explorer' } },
      },
    })
  end,
}
