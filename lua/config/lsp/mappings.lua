local u = require('utils')

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
  map('n', 'K', vim.lsp.buf.hover, opts)

  -- Formatting
  map('n', '<leader>lf', vim.lsp.buf.format, opts)

  -- Show code action
  map('n', '<leader>la', vim.lsp.buf.code_action, opts)

  -- Jumps
  -- map('n', '<leader>ld', vim.lsp.buf.definition, opts)
  map('n', '<leader>ld', '<Cmd>Glance definitions<Cr>', opts)
  -- map('n', '<leader>li', vim.lsp.buf.implementation, opts)
  map('n', '<leader>li', '<Cmd>Glance implementations<Cr>', opts)
  -- map('n', '<leader>lu', vim.lsp.buf.references, opts)
  map('n', '<leader>lu', '<Cmd>Glance references<Cr>', opts)
  map('n', '<leader>lD', vim.lsp.buf.declaration, opts)

  -- vim.keymap.set('n', 'gD', '<CMD>Glance definitions<CR>')
  -- vim.keymap.set('n', 'gR', '<CMD>Glance references<CR>')
  -- vim.keymap.set('n', 'gY', '<CMD>Glance type_definitions<CR>')
  -- vim.keymap.set('n', 'gM', '<CMD>Glance implementations<CR>')

  -- Rename
  map('n', '<leader>lr', vim.lsp.buf.rename, opts)

  -- Signature help
  map('n', '<leader>ls', vim.lsp.buf.signature_help, opts)
  map('i', '<C-q>', vim.lsp.buf.signature_help, opts)

  map('n', '<Leader>;', u.bind(vim.lsp.inlay_hint, bufnr), {
    buffer = bufnr,
    desc = 'Toggle inlayHint for current buffer',
  })
end

return M
