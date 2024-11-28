return {
  "stevearc/conform.nvim",
  enabled = true,
  config = function()
    local js_formatter = { "prettier" }
    local sql = {
      "sqlfluff",
      "sql_formatter",
      stop_after_first = true,
    }

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
        mysql = sql,
        sql = sql,
        psql = sql,
        pgsql = sql,
      },
    })
  end,
}
