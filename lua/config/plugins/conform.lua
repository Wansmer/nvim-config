return {
  "stevearc/conform.nvim",
  enabled = true,
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- Use a sub-list to run only the first available formatter
        javascript = { "prettier", "eslint" },
        javascriptreact = { "prettier", "eslint" },
        typescript = { "prettier", "eslint" },
        typescriptreact = { "prettier", "eslint" },
        vue = { "prettier", "eslint" },
        html = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        jsonc = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        toml = { { "prettierd", "prettier" } },
      },
    })
  end,
}
