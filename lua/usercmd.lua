local function wp_scratch_buf(start, scratch, lhs)
  for _, buf in ipairs({ scratch, start }) do
    vim.keymap.set('n', lhs, function()
      vim.api.nvim_buf_delete(scratch, { force = true })
      vim.keymap.del('n', lhs, { buffer = start })
    end, { buffer = buf })
  end
end

vim.api.nvim_create_user_command('DiffOrig', function()
  -- Get start buffer
  local start = vim.api.nvim_get_current_buf()

  -- `vnew` - Create empty vertical split window
  -- `set buftype=nofile` - Buffer is not related to a file, will not be written
  -- `0d_` - Remove an extra empty start row
  -- `diffthis` - Set diff mode to a new vertical split
  vim.cmd('vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis')

  -- Get scratch buffer
  local scratch = vim.api.nvim_get_current_buf()

  -- `wincmd p` - Go to the start window
  -- `diffthis` - Set diff mode to a start window
  vim.cmd('wincmd p | diffthis')

  -- Map `q` for both buffers to exit diff view and delete scratch buffer
  wp_scratch_buf(start, scratch, 'q')
end, {})

vim.api.nvim_create_user_command('Gr', function(args)
  local start = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_get_option_value('filetype', { buf = start })

  vim.cmd(
    'vnew | set buftype=nofile | read ++edit # | set filetype=' .. ft .. ' | 0d_ | g!/' .. args.args .. '/d | norm gg=G'
  )

  local scratch = vim.api.nvim_get_current_buf()
  wp_scratch_buf(start, scratch, 'q')
end, { nargs = 1 })
