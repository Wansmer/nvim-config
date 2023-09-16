return {
  'stevearc/aerial.nvim',
  -- Optional dependencies
  event = 'LspAttach',
  init = function ()
    vim.keymap.set('n', '<localleader>v', '<cmd>AerialToggle!<CR>')
  end,
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
  config = function ()
    require('aerial').setup({
      layout = {
        width = 30,
      }
    })
  end
}
