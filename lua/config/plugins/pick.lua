return {
  'echasnovski/mini.pick',
  event = 'VeryLazy',
  enabled = false,
  version = false,
  config = function()
    local MiniPick = require('mini.pick')

    MiniPick.registry.grep_live_current_buf = function(local_opts)
      -- Parse options
      local_opts = vim.tbl_deep_extend('force', { buf_id = nil, prompt = '' }, local_opts or {})
      local buf_id, prompt = local_opts.buf_id, local_opts.prompt
      local_opts.buf_id, local_opts.prompt = nil, nil

      -- Construct items
      if buf_id == nil or buf_id == 0 then
        buf_id = vim.api.nvim_get_current_buf()
      end

      local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
      local items = {}
      for i, l in ipairs(lines) do
        items[i] = { text = l, bufnr = buf_id, lnum = i }
      end

      -- Start picker while scheduling setting the query
      vim.schedule(function()
        MiniPick.set_picker_query(vim.split(prompt, ''))
      end)
      MiniPick.start({ source = { items = items, name = 'Grep live current buf' } })
    end

    local map = vim.keymap.set
    map('n', '<localleader>s', function()
      MiniPick.registry.grep_live_current_buf({ prompt = vim.fn.expand('<cword>') })
    end, { desc = 'Pick: live grep current buf <cword>' })

    map('n', '<localleader>S', function()
      MiniPick.builtin.grep(
        { pattern = '<cword>' },
        { source = { name = 'Grep (rg) <cword>: ' .. vim.fn.expand('<cword>') } }
      )
    end, { desc = 'Pick: live grep <cword> (cwd)' })

    map('n', '<localleader>f', MiniPick.builtin.files, { desc = 'Pick: Find files in (cwd)' })
    map('n', '<localleader>g', MiniPick.builtin.grep_live, { desc = 'Pick: live grep (cwd)' })
    map('n', '<localleader>b', MiniPick.builtin.buffers, { desc = 'Pick: show open buffers' })

    MiniPick.setup({
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
