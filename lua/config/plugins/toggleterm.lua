return {
  'akinsho/toggleterm.nvim',
  enabled = true,
  keys = { '<C-;>', '<Leader>g' },
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

    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = 'lazygit',
      dir = 'git_dir',
      direction = 'float',
      float_opts = {
        border = 'double',
      },
      -- function to run on opening the terminal
      on_open = function(term)
        vim.cmd('startinsert!')
        vim.api.nvim_buf_set_keymap(
          term.bufnr,
          'n',
          'q',
          '<cmd>close<CR>',
          { noremap = true, silent = true }
        )
      end,
      -- function to run on closing the terminal
      on_close = function(term)
        vim.cmd('startinsert!')
      end,
    })
    function _lazygit_toggle()
      lazygit:toggle()
    end
    map('n', '<leader>g', _lazygit_toggle, { noremap = true, silent = true })
  end,
}
