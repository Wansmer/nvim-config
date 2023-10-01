local DEV = false

return {
  'Wansmer/treesj',
  dir = DEV and '~/projects/code/personal/treesj' or nil,
  dev = DEV,
  keys = { '<Leader>m', '<Leader>M', '<leader>s', '<leader>j' },
  enabled = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local langs = require('treesj.langs').presets

    for _, nodes in pairs(langs) do
      nodes.comment = {
        both = {
          fallback = function(_)
            local res = require('mini.splitjoin').toggle()
            if not res then
              vim.cmd('normal! gww')
            end
          end,
        },
      }
    end

    require('treesj').setup({
      max_join_length = 1000,
      use_default_keymaps = true,
    })

    vim.keymap.set('n', '<Leader>M', function()
      require('treesj').toggle({ split = { recursive = true }, join = { recursive = true } })
    end, { desc = 'Toggle single/multiline block of code' })

    vim.keymap.set('n', '<Leader>m', function()
      local tsj_langs = require('treesj.langs')['presets']
      local ok, _ = pcall(vim.treesitter.get_parser, 0, vim.bo.filetype)

      if tsj_langs[vim.bo.filetype] and ok then
        require('treesj').toggle()
      else
        require('mini.splitjoin').toggle()
      end
    end)
  end,
}
