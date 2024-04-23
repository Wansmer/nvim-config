return {
  "stevearc/conform.nvim",
  enabled = true,
  config = function()
    local js_formatter = {
      { --[[ "prettierd", ]]
        "prettier",
      },
      { --[[ "eslint_d" ]]
        "eslint",
      },
    }
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        -- Use a sub-list to run only the first available formatter
        javascript = js_formatter,
        javascriptreact = js_formatter,
        typescript = js_formatter,
        typescriptreact = js_formatter,
        vue = js_formatter,
        html = {
          { --[[ "prettierd", ]]
            "prettier",
          },
        },
        json = {
          { --[[ "prettierd", ]]
            "prettier",
          },
        },
        jsonc = {
          { --[[ "prettierd", ]]
            "prettier",
          },
        },
        markdown = {
          { --[[ "prettierd", ]]
            "prettier",
          },
        },
        toml = {
          { --[[ "prettierd", ]]
            "prettier",
          },
        },
        sh = { "shfmt" },
      },
    })
  end,
}
