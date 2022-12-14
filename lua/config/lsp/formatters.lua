-- На основе https://github.com/alpha2phi/neovim-for-beginner
local ok, null_ls = pcall(require, 'null-ls')
if not ok then
  return
end

local nls_sources = require('null-ls.sources')

local M = {}

function M.list_registered_providers_names(filetype)
  local available_sources = nls_sources.get_available(filetype)
  local registered = {}
  for _, source in ipairs(available_sources) do
    for method in pairs(source.methods) do
      registered[method] = registered[method] or {}
      table.insert(registered[method], source.name)
    end
  end
  return registered
end

function M.has_formatter(filetype)
  local available =
    nls_sources.get_available(filetype, null_ls.methods.FORMATTING)
  return #available > 0
end

function M.list_registered(filetype)
  local registered_providers = M.list_registered_providers_names(filetype)
  return registered_providers[null_ls.methods.FORMATTING] or {}
end

function M.list_supported(filetype)
  local supported_formatters = nls_sources.get_supported(filetype, 'formatting')
  table.sort(supported_formatters)
  return supported_formatters
end

function M.setup(client, buf)
  local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

  local enable = false
  if M.has_formatter(filetype) then
    enable = client.name == 'null-ls'
  else
    enable = not (client.name == 'null-ls')
  end

  client.server_capabilities.documentFormattingProvider = enable
  client.server_capabilities.documentRangeFormattingProvider = enable
end

return M
