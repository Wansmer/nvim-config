return {
  "mfussenegger/nvim-lint",
  enabled = true,
  event = { "BufWritePost", "BufReadPost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { { "eslint_d" } },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint", "eslint_d" },
      vue = { "eslint_d", "stylelint" },
      html = { "tidy" },
      css = { "stylelint" },
      scss = { "stylelint" },
      less = { "stylelint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        local ok, msg = pcall(lint.try_lint)
        if not ok then
          vim.notify(msg, vim.log.levels.WARN, { title = "Nvim-Lint" })
        end
      end,
    })
  end,
}
