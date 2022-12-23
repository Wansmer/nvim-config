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
    vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
  end,
})

-- Выполнить PackerSync при сохранении plugins.lua
vim.api.nvim_create_autocmd(
  'BufWritePost',
  { pattern = 'plugins.lua', command = 'source <afile> | PackerSync' }
)

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
