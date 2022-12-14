-- Дефолтные настройки для кажддого сервера
-- Все доступные опции настроек :h vim.lsp.start_client

local set_keymap = require('config.lsp.mappings').set_keymap

local M = {}

M.on_attach = function(client, bufnr)
  -- Включает возможность форматирование диапазона
  vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
  -- Установка привязок клавиш для LSP
  set_keymap()
  -- Текущий контекст в коде
  require('config.lsp.formatters').setup(client, bufnr)
end

M.autostart = true

M.single_file_support = true

M.flags = {
  debounce_text_changes = 150,
}

-- Расширение базовых capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Для Luasnip
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Для cmp
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Для ufo
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

M.capabilities = capabilities

return M
