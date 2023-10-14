return {
  'echasnovski/mini.pick',
  event = 'VeryLazy',
  enabled = true,
  version = false,
  config = function()
    local pick = require('mini.pick')

    pick.registry.grep_live_current_buf = function(opts)
      local lines = vim.api.nvim_buf_get_lines(0, 1, -1, false)
      local items = {}

      for lnum, line in ipairs(lines) do
        items[lnum] = { text = line, lnum = lnum + 1, path = vim.fn.expand('%p') }
      end

      pick.start({
        source = {
          items = items,
          name = 'Grep current buffer',
        },
      })
    end

    local map = vim.keymap.set
    map('n', '<localleader>f', pick.builtin.files, { desc = 'Pick: Find files in (cwd>' })
    map('n', '<localleader>g', pick.builtin.grep_live, { desc = 'Pick: live grep (cwd>' })
    map('n', '<localleader>b', pick.builtin.buffers, { desc = 'Pick: show open buffers' })
    map('n', '<localleader>s', pick.registry.grep_live_current_buf, { desc = 'Pick: live grep current buf' })

    pick.setup({
      options = {
        content_from_bottom = true,
        use_cache = false,
      },
      window = {
        config = {
          relative = 'editor',
          width = vim.opt.columns:get(),
          height = 20,
          col = 0,
          row = vim.opt.lines:get(),
          style = 'minimal',
        },
      },
    })
  end,
}
