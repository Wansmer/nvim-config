local glance_ok, _ = pcall(require, 'glance')

-- Привязки клавиш для функционала LSP
local M = {}

local map = require('utils').map()

M.set_keymap = function()
  -- Общие привязки клавиш
  -- Всплывающее окно с подсказкой диагностики
  map('n', '<leader>le', vim.diagnostic.open_float)

  -- К следующему сообщению диагностики
  map('n', '<leader>ln', vim.diagnostic.goto_next)

  -- К предыдущему сообщению диагностики
  map('n', '<leader>lp', vim.diagnostic.goto_prev)

  -- Показать информацию о символе под курсором в всплывающем окне
  map('n', '<leader>lh', vim.lsp.buf.hover)

  -- Форматировать буффер
  map('n', '<leader>lf', vim.lsp.buf.format)

  -- Показать доступные действия с кодом под курсором (Show code action)
  map('n', '<leader>la', vim.lsp.buf.code_action)

  -- Перейти к определению символа под курсором (Jump to defenition)
  -- Показать имплементацию символа под курсором (Show implementation)
  -- Показать список с использованием символа под курсором (Show references)
  if glance_ok then
    map('n', '<leader>ld', '<CMD>Glance definitions<CR>')
    map('n', '<leader>li', '<CMD>Glance implementations<CR>')
    map('n', '<leader>lu', '<CMD>Glance references<CR>')
  else
    map('n', '<leader>ld', vim.lsp.buf.definition)
    map('n', '<leader>li', vim.lsp.buf.implementation)
    map('n', '<leader>lu', vim.lsp.buf.references)
  end

  -- Перейти к объявлению символа под курсором (Jump to declaration)
  map('n', '<leader>lD', vim.lsp.buf.declaration)

  -- Переименовать символ под курсором
  map('n', '<leader>lr', vim.lsp.buf.rename)

  -- Показать сигнатуру функции в всплывающем окне
  map('n', '<leader>ls', vim.lsp.buf.signature_help)
  map('i', '<C-q>', vim.lsp.buf.signature_help)
end

return M
