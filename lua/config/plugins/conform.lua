return {
  "stevearc/conform.nvim",
  enabled = true,
  config = function()
    local js_formatter = { "prettier" }
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = js_formatter,
        javascriptreact = js_formatter,
        typescript = js_formatter,
        typescriptreact = js_formatter,
        vue = js_formatter,
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier", "inject" },
        toml = { "prettier" },
        sh = { "shfmt" },
        python = { "isort", "black" },
        mysql = {
          "sqlfluff",
          "sql_formatter",
          -- stop_after_first = true,
        },
        sql = {
          "sqlfluff",
          "sql_formatter",
          -- stop_after_first = true,
        },
      },
    })
  end,
}
