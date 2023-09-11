local lsp = require('lspconfig')
local mlsp = require('mason-lspconfig')
local diagnostics = require('config.lsp.diagnostics')

diagnostics.apply()

-- Premerge user settings
local function make_config(server_name)
  local path = 'config.lsp.servers.'
  local config = require('config.lsp.default')
  local present, user_config = pcall(require, path .. server_name)
  if present then
    config = vim.tbl_deep_extend('force', config, user_config)
  end
  return config
end

local servers = mlsp.get_installed_servers()

for _, server_name in pairs(servers) do
  local opts = make_config(server_name)
  lsp[server_name].setup(opts)
end

if vim.fn.has('nvim-0.10.0') then
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.supports_method('textDocument/inlayHint', { bufnr = bufnr }) then
        vim.lsp.inlay_hint(bufnr, PREF.lsp.show_inlay_hints)
      end
    end,
  })
end
