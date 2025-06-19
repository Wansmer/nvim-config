local diagnostics = require("config.lsp.diagnostics")
require("config.lsp.autocmd")
require("config.lsp.fix_inlay_hint_hl")
diagnostics.apply()

---@diagnostic disable-next-line: param-type-mismatch
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end
