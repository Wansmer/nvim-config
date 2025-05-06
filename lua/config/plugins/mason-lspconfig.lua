return {
  "williamboman/mason-lspconfig.nvim",
  enabled = true,
  lazy = true,
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    local ensure_installed = vim
      .iter(PREF.lsp.active_servers)
      :filter(function(_, v)
        return v
      end)
      :fold({}, function(acc, k, v)
        table.insert(acc, k)
        return acc
      end)

    require("mason-lspconfig").setup({
      ensure_installed = ensure_installed,
      automatic_installation = true,
    })
  end,
}
