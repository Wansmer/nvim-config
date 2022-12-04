-- Установливать активному окну ширину не менее text_width
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local ft_ignore = {
      'nvim-tree',
      'neo-tree',
      'packer',
      -- неизвестный тип, например telescope prompt
      '',
    }
    local buf = vim.api.nvim_win_get_buf(0)
    local buftype = vim.api.nvim_buf_get_option(buf, 'ft')
    if vim.tbl_contains(ft_ignore, buftype) then
      return
    end
    local width = vim.api.nvim_win_get_width(0)
    if width < PREF.common.text_width then
      vim.api.nvim_win_set_width(0, PREF.common.text_width)
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
