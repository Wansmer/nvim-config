return {
  "mfussenegger/nvim-lint",
  enabled = true,
  event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { { "eslint_d", "eslint" } },
      javascriptreact = { { "eslint_d", "eslint" } },
      typescript = { { "eslint_d", "eslint" } },
      typescriptreact = { { "eslint_d", "eslint" } },
      vue = { { "eslint_d", "eslint" }, "stylelint" },
      html = { "tidy" },
      css = { "stylelint" },
      scss = { "stylelint" },
      less = { "stylelint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
