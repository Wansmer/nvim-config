local config = {
  virtual_text = PREF.lsp.virtual_text,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.HINT] = '',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
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
end

return M
