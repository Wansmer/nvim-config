local config = {
  virtual_text = PREF.lsp.virtual_text,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
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

local M = {}

function M.toggle_diagnostics()
  local state = PREF.lsp.show_diagnostic
  PREF.lsp.show_diagnostic = not state
  if state then
    vim.diagnostic.disable()
    return
  end
  vim.diagnostic.enable()
end

function M.apply()
  vim.diagnostic.config(config)

  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
end

return M
