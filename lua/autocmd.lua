-- Sets minimum width of current window equals to textwidth
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local ft_ignore = { '', 'nvim-tree', 'neo-tree', 'packer', 'query' }
    local buf = vim.api.nvim_win_get_buf(0)
    local buftype = vim.api.nvim_buf_get_option(buf, 'ft')

    if vim.tbl_contains(ft_ignore, buftype) then
      return
    end

    local width = vim.api.nvim_win_get_width(0)

    if width < PREF.common.textwidth then
      vim.api.nvim_win_set_width(0, PREF.common.textwidth)
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
  end,
})

-- Rid auto comment for new string
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- Autoformatting
if PREF.lsp.format_on_save then
  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
      local client = vim.lsp.get_active_clients({ bufnr = 0 })[1]
      if client then
        vim.lsp.buf.format()
      end
    end,
  })
end

-- Jump to the last place you’ve visited in a file before exiting
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local ignore_ft = { 'neo-tree', 'toggleterm', 'lazy' }
    local ft = vim.api.nvim_buf_get_option(0, 'filetype')
    if not vim.tbl_contains(ignore_ft, ft) then
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('modules.key_listener')
    require('modules.mode_nr')
    require('modules.thincc')
    require('usercmd')
  end,
})

-- Set default colorcolumn
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.api.nvim_win_set_option(0, 'colorcolumn', tostring(PREF.common.textwidth))
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function(data)
    vim.api.nvim_buf_set_option(data.buf, 'textwidth', 80)
    vim.api.nvim_win_set_option(vim.api.nvim_get_current_win(), 'colorcolumn', '80')
    require('modules.markdown')
  end,
})

-- vim.api.nvim_create_autocmd('User', {
--   pattern = { 'WatcherChangedFile', 'WatcherCreatedFile', 'WatcherDeletedFile' },
--   callback = function(data)
--     vim.print(data)
--   end
-- })
