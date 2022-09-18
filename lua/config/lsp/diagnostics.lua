-- Настройки для отображения сообщений диагностики
local config = {
  virtual_text = PREF.lsp.virtual_text,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  -- Подробнее о настройках :h nvim_open_win, :h open_float
  float = {
    source = true,
    focusable = true,
    style = 'minimun',
    border = PREF.ui.border,
  },
}

local signs = {
  Error = '',
  Warn = '',
  Hint = '',
  Info = '',
}

vim.diagnostic.config(config)
vim.lsp.handlers['textDocument/hover'] =
  vim.lsp.with(vim.lsp.handlers.hover, config.float)

vim.lsp.handlers['textDocument/signatureHelp'] =
  vim.lsp.with(vim.lsp.handlers.signature_help, config.float)

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end
