-- Установливать активному окну ширину не менее textwidth
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

-- Убирает подсветку после поиска после ухода со строки
local hl_ns = vim.api.nvim_create_namespace('hl_search')

local function manage_hlsearch(char)
  local keys = { '<CR>', 'n', 'N', '*', '#', '?', '/' }
  if vim.fn.mode() == 'n' then
    local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end

vim.on_key(manage_hlsearch, hl_ns)