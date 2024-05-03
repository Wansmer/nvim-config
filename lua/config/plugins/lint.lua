return {
  "mfussenegger/nvim-lint",
  enabled = true,
  event = { "VeryLazy" },
  config = function()
    local lint = require("lint")
    ---@type "eslint_d"|"eslint"
    -- local js_linter = "eslint"

    lint.linters_by_ft = {
      -- javascript = { js_linter },
      -- javascriptreact = { { js_linter } },
      -- typescript = { js_linter },
      -- typescriptreact = { js_linter },
      vue = {
        -- js_linter,
        "stylelint",
      },
      html = { "tidy" },
      css = { "stylelint" },
      scss = { "stylelint" },
      less = { "stylelint" },
      yml = { "ansible-lint" },
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
