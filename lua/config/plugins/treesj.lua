local DEV = false

return {
  'Wansmer/treesj',
  dir = DEV and '~/projects/code/personal/treesj' or nil,
  dev = DEV,
  keys = { '<Leader>m', '<Leader>M' },
  enabled = true,
  config = function()
    require('treesj').setup({
      max_join_length = 1000,
    })
    vim.keymap.set('n', '<Leader>M', function()
      require('treesj').toggle({ split = { recursive = true }, join = { recursive = true } })
    end, { desc = 'Toggle single/multiline block of code' })
  end,
}
