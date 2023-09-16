local map = vim.keymap.set

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Set Glance.nvim mappings',
  callback = function(event)
    -- `defer_fn` here because must to be set after `on_attach` lspconfig method
    vim.defer_fn(function()
      map('n', 'gd', '<Cmd>Glance definitions<Cr>', {
        buffer = event.buf,
        desc = 'Glance definitions',
      })
      map('n', 'gi', '<Cmd>Glance implementations<Cr>', {
        buffer = event.buf,
        desc = 'Glance implementations',
      })
      map('n', 'gr', '<Cmd>Glance references<Cr>', {
        buffer = event.buf,
        desc = 'Glance references',
      })
      vim.keymap.set('n', 'go', '<Cmd>Glance type_definitions<Cr>', {
        buffer = event.buf,
        desc = 'Glance type definitions',
      })
    end, 100)
  end,
})

return {
  'dnlhc/glance.nvim',
  event = 'LspAttach',
  config = function()
    local actions = require('glance').actions

    require('glance').setup({
      border = {
        enable = true, -- Show window borders. Only horizontal borders allowed
        top_char = '―',
        bottom_char = '―',
      },
      preview_win_opts = { -- Configure preview window options
        cursorline = false,
        number = true,
        wrap = true,
        statuscolumn = '  %=%l  ',
      },
      theme = { -- This feature might not work properly in nvim-0.7.2
        enable = true, -- Will generate colors for the plugin based on your current colorscheme
        mode = 'brighten', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
      },
      mappings = {
        list = {
          ['j'] = actions.next, -- Bring the cursor to the next item in the list
          ['k'] = actions.previous, -- Bring the cursor to the previous item in the list
          ['<Down>'] = actions.next,
          ['<Up>'] = actions.previous,
          ['<Tab>'] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
          ['<S-Tab>'] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
          ['<C-u>'] = actions.preview_scroll_win(5),
          ['<C-d>'] = actions.preview_scroll_win(-5),
          ['<C-v>'] = actions.jump_vsplit,
          ['<C-g>'] = actions.jump_split,
          ['t'] = actions.jump_tab,
          ['<CR>'] = actions.jump,
          ['o'] = actions.jump,
          ['l'] = actions.open_fold,
          ['h'] = actions.close_fold,
          ['<C-h>'] = actions.enter_win('preview'), -- Focus preview window
          ['q'] = actions.close,
          ['Q'] = actions.close,
          ['<Esc>'] = actions.close,
          ['<C-c>'] = actions.close,
          ['<C-q>'] = actions.quickfix,
          -- ['<Esc>'] = false -- disable a mapping
        },
        preview = {
          ['Q'] = actions.close,
          ['<Tab>'] = actions.next_location,
          ['<S-Tab>'] = actions.previous_location,
          ['<C-l>'] = actions.enter_win('list'), -- Focus list window
        },
        hooks = {},
      },
      winbar = {
        enable = true, -- Available strating from nvim-0.8+
      },
    })
  end,
}
