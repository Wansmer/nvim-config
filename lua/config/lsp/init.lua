local lsp = require('lspconfig')
local mason = require('mason')
local mason_lsp = require('mason-lspconfig')
-- local ts = require('typescript')

require('config.lsp.diagnostics')

-- Список lsp для предустановки
local ensure_installed = {
  'sumneko_lua',
  -- 'tsserver',
  'volar',
  'cssls',
  'html',
  'emmet_ls',
  'jsonls',
  'marksman',
}

-- объединение общих настроек с пользовательскими
local function make_config(server_name)
  local config = require('config.lsp.default')
  local present, user_config =
  pcall(require, 'config.lsp.servers.' .. server_name)
  if present then
    config = vim.tbl_deep_extend('force', config, user_config)
  end
  return config
end

mason.setup()
mason_lsp.setup({
  ensure_installed = ensure_installed,
  automatic_installation = true,
})

local servers = mason_lsp.get_installed_servers()

for _, server_name in pairs(servers) do
  local opts = make_config(server_name)
  -- if server_name == 'tsserver' then
  --   ts.setup(opts)
  -- else
  --   lsp[server_name].setup(opts)
  -- end
  lsp[server_name].setup(opts)
end

require('config.lsp.null-ls')
