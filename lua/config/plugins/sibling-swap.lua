return {
  'Wansmer/sibling-swap.nvim',
  enabled = true,
  keys = {
    '<C-.>',
    '<C-,>',
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('sibling-swap').setup({
      use_default_keymaps = true,
      keymaps = {
        ['<space>.'] = 'swap_with_right',
        ['<space>,'] = 'swap_with_left',
        ['<C-.>'] = 'swap_with_right_with_opp',
        ['<C-,>'] = 'swap_with_left_with_opp',
      },
    })
  end,
}
