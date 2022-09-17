-- Привязки клавиш для функционала LSP
local M = {}

local map = vim.keymap.set

M.set_keymap = function()
  local opts = { noremap = true, silent = true }
  local bufopts = { noremap = true, silent = true, buffer = 0 }

  -- Общие привязки клавиш
  -- Всплывающее окно с подсказкой диагностики
  map('n', '<leader>le', vim.diagnostic.open_float, opts)
  -- К следующему сообщению диагностики
  map('n', '<leader>ln', vim.diagnostic.goto_next, opts)
  -- К предыдущему сообщению диагностики
  map('n', '<leader>lp', vim.diagnostic.goto_prev, opts)
  -- Показать информацию о символе под курсором в всплывающем окне
  map('n', '<leader>lh', vim.lsp.buf.hover, bufopts)
  -- Форматировать буффер
  map('n', '<leader>lf', vim.lsp.buf.format, bufopts)
  -- TODO: Разобраться, почему не работает форматирование выделенного
  -- Форматировать выделенный фрагмент
  map('v', '<leader>lf', vim.lsp.buf.range_formatting, bufopts)
  -- Показать доступные действия с кодом под курсором (Show code action)
  map('n', '<leader>la', vim.lsp.buf.code_action, bufopts)
  -- Перейти к определению символа под курсором (Jump to defenition)
  map('n', '<leader>ld', vim.lsp.buf.definition, bufopts)
  -- Перейти к объявлению символа под курсором (Jump to declaration)
  map('n', '<leader>lD', vim.lsp.buf.declaration, bufopts)
  -- Показать список с использованием синвола под курсором (Show implementation)
  map('n', '<leader>li', vim.lsp.buf.implementation, bufopts)
  -- Переименовать символ под курсором
  map('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
  -- Показать сигнатуру функции в всплывающем окне
  map('n', '<leader>ls', vim.lsp.buf.signature_help, bufopts)
  map('i', '<C-q>', vim.lsp.buf.signature_help, bufopts)
end

return M
