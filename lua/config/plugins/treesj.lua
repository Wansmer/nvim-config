local DEV = false

return {
  'Wansmer/treesj',
  dir = DEV and '~/projects/code/personal/treesj' or nil,
  dev = DEV,
  keys = { '<Leader>m', '<Leader>M' },
  enabled = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local langs = require('treesj.langs').presets

    for _, nodes in pairs(langs) do
      nodes.comment = {
        both = {
          fallback = function(tsn)
            local res = require('mini.splitjoin').toggle()
            if not res then
              vim.cmd('normal! gww')
            end
          end,
        },
      }
    end

    require('treesj').setup({ max_join_length = 1000 })

    vim.keymap.set('n', '<Leader>M', function()
      require('treesj').toggle({ split = { recursive = true }, join = { recursive = true } })
    end, { desc = 'Toggle single/multiline block of code' })
  end,
}
