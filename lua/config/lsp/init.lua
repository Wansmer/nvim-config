local lsp = require('lspconfig')
local diagnostics = require('config.lsp.diagnostics')

diagnostics.apply()

-- Premerge user settings
local function make_config(server_name)
  local path = 'config.lsp.servers.'
  local config = require('config.lsp.default')
  local present, user_config = pcall(require, path .. server_name)
  if present then config = vim.tbl_deep_extend('force', config, user_config) end
  return config
end

local servers = {
  'volar',
  'tsserver',
  'lua_ls',
  'html',
  'emmet_ls',
  'marksman',
  'cssls',
  'jsonls',
  'rust_analyzer',
  'sqlls',
  'bashls',
}

for _, server_name in pairs(servers) do
  local opts = make_config(server_name)
  lsp[server_name].setup(opts)
end
