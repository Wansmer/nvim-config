-- Минимальная ширина текущего окна = textwidth
local ft_ignore = { 'nvim-tree', 'neo-tree', 'packer', '' }

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
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

-- Подсветить скопированное
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
  end,
})

-- Отключает автокомментирование новой строки
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- Автоформатирование при сохранении
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

-- Перейти к месту в файле, на котором остановились
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Загрузка модулей по событию VeryLazy (Lazy.nvim)
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('modules.key_listener')
    require('modules.mode_nr')
    require('modules.thincc')
    require('usercmd')
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.api.nvim_win_set_option(0, 'colorcolumn', tostring(PREF.common.textwidth))
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.bo.textwidth = 80
    vim.api.nvim_win_set_option(0, 'colorcolumn', '80')
    require('modules.markdown')
  end,
})

-- vim.api.nvim_create_autocmd('User', {
--   pattern = { 'WatcherChangedFile', 'WatcherCreatedFile', 'WatcherDeletedFile' },
--   callback = function(data)
--     vim.print(data)
--   end
-- })
