return {
  'akinsho/toggleterm.nvim',
  enabled = true,
  keys = '<C-;>',
  config = function()
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
      local opts = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
  end,
}
