local ndir = 'config.plugins.neo-tree'
local deps = require('config.plugins.neo-tree.deps')

return {
  'nvim-neo-tree/neo-tree.nvim',
  cmd = 'Neotree',
  init = function()
    vim.keymap.set('n', '<LocalLeader>e', '<Cmd>Neotree focus toggle<Cr>', { desc = 'Open file explorer' })
    vim.keymap.set('x', '<LocalLeader>e', '<Esc><Cmd>Neotree focus toggle<Cr>', { desc = 'Open file explorer' })
  end,
  dependencies = deps,
  config = function()
    local mappings = require('config.plugins.neo-tree.mappings')
    -- See: https://github.com/nvim-neo-tree/neo-tree.nvim/blob/main/lua/neo-tree/defaults.lua
    require('neo-tree').setup({
      sources = { 'filesystem', 'git_status' },
      add_blank_line_at_top = true,
      enable_modified_markers = false,

      source_selector = {
        winbar = true,
        content_layout = 'center',
        sources = { { source = 'filesystem' }, { source = 'git_status' } },
      },

      default_component_configs = {
        git_status = {
          symbols = {
            deleted = '',
            renamed = '➜',
            untracked = '',
            ignored = '◌',
            unstaged = '󰜀',
            staged = '',
            conflict = '',
          },
        },
      },

      window = {
        width = 30,
        mappings = mappings.window,
      },

      filesystem = {
        window = {
          mappings = mappings.filesystem,
        },
      },

      git_status = {
        window = {
          mappings = mappings.git_status,
        },
      },
    })

    vim.api.nvim_create_autocmd({ 'VimResume' }, {
      desc = 'Update git_status in tree after fg',
      callback = function()
        require('neo-tree.sources.git_status').refresh()
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Remove statuscolumn for NeoTree window',
      pattern = 'neo-tree',
      callback = function()
        vim.schedule(function()
          local winid = vim.api.nvim_get_current_win()
          if vim.wo[winid] ~= '' then
            vim.wo[winid].statuscolumn = ''
          end
        end)
      end,
    })
  end,
}
