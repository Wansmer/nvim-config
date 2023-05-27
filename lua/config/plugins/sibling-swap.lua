local DEV = false

return {
  'Wansmer/sibling-swap.nvim',
  dir = DEV and '~/projects/code/personal/sibling-swap' or nil,
  dev = DEV,
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
        ['<Leader>.'] = 'swap_with_right',
        ['<Leader>,'] = 'swap_with_left',
        ['<C-.>'] = 'swap_with_right_with_opp',
        ['<C-,>'] = 'swap_with_left_with_opp',
      },
    })
  end,
}
