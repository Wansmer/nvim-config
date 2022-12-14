return {
  'Wansmer/sibling-swap.nvim',
  enabled = true,
  keys = {
    '<C-.>',
    '<C-,>',
    '<C-ю>',
    '<C-б>',
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('sibling-swap').setup({
      use_default_keymaps = true,
      keymaps = {
        ['<Leader>.'] = 'swap_with_right',
        ['<Leader>,'] = 'swap_with_left',
        ['<C-.>'] = 'swap_with_right_with_opp',
        ['<C-,>'] = 'swap_with_left_with_opp',
        ['<C-ю>'] = 'swap_with_right_with_opp',
        ['<C-б>'] = 'swap_with_left_with_opp',
      },
    })
  end,
}
