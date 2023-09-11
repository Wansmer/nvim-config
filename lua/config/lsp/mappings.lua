local u = require('utils')

local M = {}

local map = vim.keymap.set

---Setup mappings
---@param _ table Client
---@param bufnr integer
M.set_keymap = function(_, bufnr)
  -- Diagnostics
  map('n', '<leader>le', vim.diagnostic.open_float, { buffer = bufnr, desc = 'Open diagnostic float on the line' })
  map('n', '<leader>ln', vim.diagnostic.goto_next, { buffer = bufnr, desc = 'Go to next diagnostic' })
  map('n', '<leader>lp', vim.diagnostic.goto_prev, { buffer = bufnr, desc = 'Go to prev diagnostic' })
  map('n', '<Leader>td', u.lazy_rhs_cb('config.lsp.diagnostics', 'toggle_diagnostics'), {
    desc = 'Toggle diagnostic',
    buffer = bufnr,
  })

  -- Hover (symbol info)
  map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'Show symbol info' })

  -- Formatting
  map('n', '<leader>lf', vim.lsp.buf.format, { buffer = bufnr, desc = 'Format buffer' })

  -- Show code action
  map('n', '<leader>la', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'Show available code action' })

  -- Jumps
  -- map('n', '<leader>ld', vim.lsp.buf.definition, { buffer = bufnr, desc = '' })
  map('n', '<leader>ld', '<Cmd>Glance definitions<Cr>', { buffer = bufnr, desc = 'Definitions' })
  -- map('n', '<leader>li', vim.lsp.buf.implementation, { buffer = bufnr, desc = '' })
  map('n', '<leader>li', '<Cmd>Glance implementations<Cr>', { buffer = bufnr, desc = 'Implementations' })
  -- map('n', '<leader>lu', vim.lsp.buf.references, { buffer = bufnr, desc = '' })
  map('n', '<leader>lu', '<Cmd>Glance references<Cr>', { buffer = bufnr, desc = 'References' })
  map('n', '<leader>lD', vim.lsp.buf.declaration, { buffer = bufnr, desc = 'Declarations' })

  -- vim.keymap.set('n', 'gD', '<CMD>Glance definitions<CR>')
  -- vim.keymap.set('n', 'gR', '<CMD>Glance references<CR>')
  -- vim.keymap.set('n', 'gY', '<CMD>Glance type_definitions<CR>')
  -- vim.keymap.set('n', 'gM', '<CMD>Glance implementations<CR>')

  -- Rename
  map('n', '<leader>lr', vim.lsp.buf.rename, { buffer = bufnr, desc = 'Rename symbol' })

  -- Signature help
  map('n', '<leader>ls', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature help' })
  map('i', '<C-q>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'Signature help' })

  map('n', '<Leader>;', u.bind(vim.lsp.inlay_hint, bufnr), {
    buffer = bufnr,
    desc = 'Toggle inlayHint for current buffer',
  })
end

return M
