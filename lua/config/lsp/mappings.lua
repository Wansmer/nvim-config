local M = {}

local map = vim.keymap.set

---Setup mappings
---@param _ table Client
---@param bufnr integer
M.set_keymap = function(_, bufnr)
  local opts = { buffer = bufnr }

  -- Diagnostics
  map('n', '<leader>le', vim.diagnostic.open_float, opts)
  map('n', '<leader>ln', vim.diagnostic.goto_next, opts)
  map('n', '<leader>lp', vim.diagnostic.goto_prev, opts)

  -- Hover (symbol info)
  map('n', '<leader>lh', vim.lsp.buf.hover, opts)

  -- Formatting
  map('n', '<leader>lf', vim.lsp.buf.format, opts)

  -- Show code action
  map('n', '<leader>la', vim.lsp.buf.code_action, opts)

  -- Jumps
  map('n', '<leader>ld', vim.lsp.buf.definition, opts)
  map('n', '<leader>li', vim.lsp.buf.implementation, opts)
  map('n', '<leader>lu', vim.lsp.buf.references, opts)
  map('n', '<leader>lD', vim.lsp.buf.declaration, opts)

  -- Rename
  map('n', '<leader>lr', vim.lsp.buf.rename, opts)

  -- Signature help
  map('n', '<leader>ls', vim.lsp.buf.signature_help, opts)
  map('i', '<C-q>', vim.lsp.buf.signature_help, opts)
end

return M
