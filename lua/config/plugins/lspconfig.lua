return {
  "neovim/nvim-lspconfig",
  enabled = true,
  event = { "BufReadPre" },
  dependencies = {
    "b0o/SchemaStore.nvim",
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("config.lsp")
    local ensure_installed = vim
      .iter(PREF.lsp.active_servers)
      :filter(function(_, v)
        return v
      end)
      :fold({}, function(acc, k, v)
        table.insert(acc, k)
        return acc
      end)

    vim.lsp.enable(ensure_installed)
  end,
}
