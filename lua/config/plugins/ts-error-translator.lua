return {
  "dmmulroy/ts-error-translator.nvim",
  enabled = true,
  ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  config = function()
    require("ts-error-translator").setup({})
  end,
}
