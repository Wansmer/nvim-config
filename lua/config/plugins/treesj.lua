local DEV = false

return {
  'Wansmer/treesj',
  enabled = true,
  dir = DEV and '~/projects/code/personal/treesj' or nil,
  dev = DEV,
  keys = { '<Leader>m', '<Leader>M', '<leader>s', '<leader>j' },
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

    local function get_pos_lang(node)
      local c = vim.api.nvim_win_get_cursor(0)
      local range = { c[1] - 1, c[2], c[1] - 1, c[2] }
      local buf = vim.api.nvim_get_current_buf()
      local ok, parser = pcall(vim.treesitter.get_parser, buf, vim.treesitter.language.get_lang(vim.bo[buf].ft))
      if not ok then
        return ''
      end
      local current_tree = parser:language_for_range(range)
      return current_tree:lang()
    end

    vim.keymap.set('n', '<Leader>m', function()
      local tsj_langs = require('treesj.langs')['presets']
      local lang = get_pos_lang()
      print('Lang: ' .. lang)
      if lang ~= '' and tsj_langs[lang] then
        require('treesj').toggle()
      else
        require('mini.splitjoin').toggle()
      end
    end)
  end,
}
