local config = {
  virtual_text = PREF.lsp.virtual_text,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = true,
    focusable = true,
    style = "minimun",
    border = PREF.ui.border,
  },
}

local M = {}

function M.toggle_diagnostics()
  vim.diagnostic.enable(vim.diagnostic.is_enabled())
end

function M.apply()
  vim.diagnostic.config(config)

  local signs = {
    Error = config.signs.text[vim.diagnostic.severity.ERROR],
    Warn = config.signs.text[vim.diagnostic.severity.WARN],
    Hint = config.signs.text[vim.diagnostic.severity.HINT],
    Info = config.signs.text[vim.diagnostic.severity.INFO],
  }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

return M
