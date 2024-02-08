return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  enabled = true,
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    require("mason-tool-installer").setup({

      ensure_installed = {
        -- LSP
        "ansible-language-server",
        "bash-language-server",
        "css-lsp",
        "emmet-ls",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "marksman",
        "tailwindcss-language-server",
        "typescript-language-server",

        -- Linters
        "ansible-lint",
        "eslint_d",
        "yamllint",

        -- Formatters
        "prettierd",
        "stylua",
        "shfmt",
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
    })
  end,
}
