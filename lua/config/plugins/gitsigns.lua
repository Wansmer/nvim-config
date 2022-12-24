return {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
  enabled = true,
  config = function()
    local gitsigns = require('gitsigns')
    gitsigns.setup({
      signs = {
        add = {
          hl = 'GitSignsAdd',
          text = '│',
          numhl = 'GitSignsAddNr',
          linehl = 'GitSignsAddLn',
        },
        change = {
          hl = 'GitSignsChange',
          -- text = '▎',
          text = '│',
          numhl = 'GitSignsChangeNr',
          linehl = 'GitSignsChangeLn',
        },
        delete = {
          hl = 'GitSignsDelete',
          text = '_',
          numhl = 'GitSignsDeleteNr',
          linehl = 'GitSignsDeleteLn',
        },
        topdelete = {
          hl = 'GitSignsDelete',
          text = '‾',
          numhl = 'GitSignsDeleteNr',
          linehl = 'GitSignsDeleteLn',
        },
        changedelete = {
          hl = 'GitSignsChange',
          text = '~',
          numhl = 'GitSignsChangeNr',
          linehl = 'GitSignsChangeLn',
        },
      },
      signcolumn = PREF.git.show_signcolumn, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = PREF.git.show_blame, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter_opts = {
        relative_time = true,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000,
      preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
      yadm = {
        enable = false,
      },
    })

    local map = vim.keymap.set

    map('n', '<leader>gp', ':Gitsigns prev_hunk<CR>')
    map('n', '<leader>gn', ':Gitsigns next_hunk<CR>')
    map('n', '<leader>gs', ':Gitsigns preview_hunk<CR>')
    map('n', '<leader>gd', ':Gitsigns diffthis<CR>')
    map('n', '<leader>ga', ':Gitsigns stage_hunk<CR>')
    map('n', '<leader>gr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>gA', ':Gitsigns stage_buffer<CR>')
    map('n', '<leader>gR', ':Gitsigns reset_buffer<CR>')
  end,
}
