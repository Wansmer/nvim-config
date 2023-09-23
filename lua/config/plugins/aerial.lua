return {
  'stevearc/aerial.nvim',
  -- Optional dependencies
  event = 'LspAttach',
  init = function()
    vim.keymap.set('n', '<localleader>v', '<cmd>AerialToggle<CR>')
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('aerial').setup({
      on_attach = function(bufnr)
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
      layout = {
        width = 30,
        win_opts = {
          statuscolumn = ' ',
          winhighlight = table.concat({
            'Normal:AerialNormal',
            'WinBar:AerialNormal',
            'SignColumn:AerialNormal',
            'FoldColumn:AerialNormal',
            'LineNr:AerialNormal',
            'TabLine:AerialNormal',
            'CursorLine:AerialNormal',
          }, ','),
        },
      },
      autojump = true,
      post_jump_cmd = 'normal! zt',
      show_guides = true,
    })
  end,
}
