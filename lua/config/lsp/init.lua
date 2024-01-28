local lsp = require("lspconfig")
local mlsp = require("mason-lspconfig")
local diagnostics = require("config.lsp.diagnostics")
local float = require("config.lsp.floats")
require("config.lsp.autocmd")
diagnostics.apply()
float.apply()

-- Premerge user settings
local function make_config(server_name)
  local path = "config.lsp.servers."
  local config = require("config.lsp.default")
  local present, user_config = pcall(require, path .. server_name)
  if present then
    config = vim.tbl_deep_extend("force", config, user_config)
  end
  return config
end

local servers = mlsp.get_installed_servers()

for _, server_name in pairs(servers) do
  if PREF.lsp.active_servers[server_name] and server_name ~= "tsserver" then
    local opts = make_config(server_name)
    lsp[server_name].setup(opts)
  end
end

---@diagnostic disable-next-line: param-type-mismatch
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end
