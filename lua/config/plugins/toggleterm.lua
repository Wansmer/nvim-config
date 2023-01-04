return {
  'akinsho/toggleterm.nvim',
  enabled = true,
  keys = { '<C-;>' },
  config = function()
    local map = require('langmapper').map
    local toggleterm = require('toggleterm')

    toggleterm.setup({
      size = 15,
      open_mapping = [[<C-;>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 3,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'horizontal',
      close_on_exit = true,
      shell = vim.o.shell,
    })

    function _G.set_terminal_keymaps()
      map('t', '<esc>', [[<C-\><C-n>]])
      map('t', 'jk', [[<C-\><C-n>]])
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end,
}
