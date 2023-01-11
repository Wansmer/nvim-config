vim.api.nvim_create_user_command('H', function(args)
  vim.cmd('vert h ' .. args.args)
end, { nargs = 1, complete = 'help' })
