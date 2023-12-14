return {
  "stevearc/conform.nvim",
  enabled = true,
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- Use a sub-list to run only the first available formatter
        javascript = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        javascriptreact = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        typescript = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        typescriptreact = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        vue = { { "prettierd", "prettier" }, { "eslint_d", "eslint" } },
        html = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        toml = { { "prettierd", "prettier" } },
      },
    })
  end,
}
