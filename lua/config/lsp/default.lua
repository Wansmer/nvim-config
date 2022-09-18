-- Дефолтные настройки для кажддого сервера
-- Все доступные опции настроек :h vim.lsp.start_client

local navic = require('nvim-navic')
local set_keymap = require('config.lsp.mappings').set_keymap

local function is_support_symbol(client)
  return client.server_capabilities.documentSymbolProvider
end

local M = {}

M.on_attach = function(client, bufnr)
  -- Включает возможность форматирование диапазона
  vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
  -- Установка привязок клавиш для LSP
  set_keymap()
  -- Текущий контекст в коде
  if client.name ~= 'null-ls' and is_support_symbol(client) then
    navic.attach(client, bufnr)
  end
  require('config.lsp.formatters').setup(client, bufnr)
end

M.autostart = true

M.single_file_support = true

M.flags = {
  debounce_text_changes = 150,
}

-- Расширение базовых capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

M.capabilities = capabilities

return M
