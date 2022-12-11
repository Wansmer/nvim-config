local ok, mlsp = pcall(require, 'mason-lspconfig')

if not ok then
  return
end

-- Список lsp для предустановки
local ensure_installed = PREF.lsp.preinstall_servers

mlsp.setup({
  ensure_installed = ensure_installed,
  automatic_installation = true,
})
