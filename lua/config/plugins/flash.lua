return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  keys = {
    {
      'm',
      mode = { 'n', 'x', 'o' },
      function()
        -- default options: exact mode, multi window, all directions, with a backdrop
        require('flash').jump()
      end,
      desc = 'Flash',
    },
    {
      'M',
      mode = { 'n', 'o', 'x' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
  },
  config = function()
    require('flash').setup()
  end,
}
