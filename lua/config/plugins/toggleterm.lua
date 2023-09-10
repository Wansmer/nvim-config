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
      start_in_insert = true,
      insert_mappings = true,
      persist_size = false,
      persist_mode = false,
      direction = 'float', -- 'float', 'horizontal', 'vertical', 'tab'
      close_on_exit = true,
      shell = vim.o.shell,
      highlights = {
        Normal = { link = 'NeoTreeNorml' },
      },
      float_opts = {
        border = { '', '', '', ' ', ' ', ' ', ' ', ' ' },
        relative = 'editor',
        width = vim.opt.columns:get(),
        height = 20,
        col = 0,
        row = vim.opt.lines:get(),
        style = 'minimal',
        title = 'Hello KITTY',
        title_pos = 'left',
        noautocmd = true,
      },
      on_open = function(term)
        local ns = vim.api.nvim_create_namespace('ToggleTerm')
        vim.api.nvim_set_hl(ns, 'Normal', { link = 'TTNormal' })
        vim.api.nvim_set_hl(ns, 'FloatBorder', { link = 'TTBorder' })
        vim.api.nvim_win_set_hl_ns(term.window, ns)
      end,
    })

    vim.api.nvim_create_autocmd('filetype', {
      pattern = 'toggleterm',
      callback = function()
        -- vim.wo.statuscolumn = '    '
        vim.wo.cursorline = false
      end,
    })
  end,
}
