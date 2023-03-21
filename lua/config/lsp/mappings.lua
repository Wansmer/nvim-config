local glance_ok, _ = pcall(require, 'glance')

-- Привязки клавиш для функционала LSP
local M = {}

local map = vim.keymap.set

---Setup mappings
---@param _ table Client
---@param bufnr integer
M.set_keymap = function(_, bufnr)
  local opts = { buffer = bufnr }
  -- Общие привязки клавиш
  -- Всплывающее окно с подсказкой диагностики
  map('n', '<leader>le', vim.diagnostic.open_float, opts)

  -- К следующему сообщению диагностики
  map('n', '<leader>ln', vim.diagnostic.goto_next, opts)

  -- К предыдущему сообщению диагностики
  map('n', '<leader>lp', vim.diagnostic.goto_prev, opts)

  -- Показать информацию о символе под курсором в всплывающем окне
  map('n', '<leader>lh', vim.lsp.buf.hover, opts)

  -- Форматировать буффер
  map('n', '<leader>lf', vim.lsp.buf.format, opts)

  -- Показать доступные действия с кодом под курсором (Show code action)
  map('n', '<leader>la', vim.lsp.buf.code_action, opts)

  -- Перейти к определению символа под курсором (Jump to defenition)
  -- Показать имплементацию символа под курсором (Show implementation)
  -- Показать список с использованием символа под курсором (Show references)
  if glance_ok then
    map('n', '<leader>ld', '<CMD>Glance definitions<CR>', opts)
    map('n', '<leader>li', '<CMD>Glance implementations<CR>', opts)
    map('n', '<leader>lu', '<CMD>Glance references<CR>', opts)
  else
    map('n', '<leader>ld', vim.lsp.buf.definition, opts)
    map('n', '<leader>li', vim.lsp.buf.implementation, opts)
    map('n', '<leader>lu', vim.lsp.buf.references, opts)
  end

  -- Перейти к объявлению символа под курсором (Jump to declaration)
  map('n', '<leader>lD', vim.lsp.buf.declaration, opts)

  -- Переименовать символ под курсором
  map('n', '<leader>lr', vim.lsp.buf.rename, opts)

  -- Показать сигнатуру функции в всплывающем окне
  map('n', '<leader>ls', vim.lsp.buf.signature_help, opts)
  map('i', '<C-q>', vim.lsp.buf.signature_help, opts)
end

return M
