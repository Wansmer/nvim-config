return {
  -- NOTE: use my PR until author no fix #7
  'Wansmer/delaytrain.nvim',
  lazy = false,
  enabled = true,
  config = function()
    require('delaytrain').setup({
      ignore_filetypes = {
        'neo-tree',
        'alpha',
        'toggleterm',
        'packer',
        'lazy',
        'TelescopePrompt',
      },
    })
  end,
}
