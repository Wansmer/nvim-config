local nvim_lsp = require("lspconfig")

return {
  cmd = { "sg", "lsp" },
  filetypes = { "typescript" },
  single_file_support = true,
  root_dir = nvim_lsp.util.root_pattern(".git", "sgconfig.yml"),
}
