vim.api.nvim_create_user_command('H', function(args)
  vim.cmd('vert h ' .. args.args)
end, { nargs = 1, complete = 'help' })

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
  for _, buf in ipairs({ scratch, start }) do
    vim.keymap.set('n', 'q', function()
      vim.api.nvim_buf_delete(scratch, { force = true })
      vim.keymap.del('n', 'q', { buffer = start })
    end, { buffer = buf })
  end
end, {})
