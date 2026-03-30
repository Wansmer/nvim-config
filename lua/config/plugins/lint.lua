return {
  "mfussenegger/nvim-lint",
  enabled = true,
  event = { "VeryLazy" },
  config = function()
    local lint = require("lint")
    ---@type "eslint_d"|"eslint"
    local js_linter = "eslint"

    local linters = lint.linters
    linters.sqlfluff.args = { "lint", "--format=json" }

    lint.linters_by_ft = {
      javascript = { "biome", js_linter },
      javascriptreact = { "biome", js_linter },
      typescript = { "biome", js_linter },
      typescriptreact = { "biome", js_linter },
      vue = { "biome", js_linter, "stylelint" },
      svelte = { "biome", js_linter, "stylelint" },
      html = { "tidy" },
      css = { "stylelint" },
      scss = { "stylelint" },
      less = { "stylelint" },
      yml = { "ansible-lint" },
      sql = { "sqlfluff" },
      mysql = { "sqlfluff" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        local ok, msg = pcall(lint.try_lint)
        -- if not ok then
        --   vim.notify(msg, vim.log.levels.WARN, { title = "Nvim-Lint" })
        -- end
      end,
    })
  end,
}
