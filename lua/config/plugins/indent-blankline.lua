return {
  'lukas-reineke/indent-blankline.nvim',
  enabled = true,
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    require('ibl').setup({
      indent = { char = '▏' },
      scope = {
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          '*oil*',
          'neo-tree',
          'Trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
          'asm',
        },
      },
    })
  end,
  main = 'ibl',
}
