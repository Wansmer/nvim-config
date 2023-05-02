return {
  'folke/zen-mode.nvim',
  keys = {
    { '<leader>z', ':ZenMode<CR>' },
  },
  config = function()
    require('zen-mode').setup({
      on_open = function(win)
        local ft = vim.api.nvim_buf_get_option(0, 'ft')
        vim.api.nvim_win_set_width(win, vim.api.nvim_buf_get_option(0, 'tw'))

        -- For better writing
        local text = { 'markdown', 'text' }
        if vim.tbl_contains(text, ft) then
          local opts = { tw = 0, linebreak = true, wrap = true }
          for opt, val in pairs(opts) do
            vim.opt_local[opt] = val
          end
        end
      end,
    })
  end,
}
