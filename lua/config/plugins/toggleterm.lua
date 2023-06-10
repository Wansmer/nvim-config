return {
  'akinsho/toggleterm.nvim',
  enabled = true,
  keys = { '<C-;>' },
  config = function()
    local toggleterm = require('toggleterm')
    vim.keymap.set('t', '<C-d>', '<C-c>exit<Cr>')

    toggleterm.setup({
      size = 20,
      open_mapping = [[<C-;>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 3,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      persist_mode = false,
      direction = 'horizontal',
      close_on_exit = true,
      shell = vim.o.shell,
    })
  end,
}
