return {
  "Sebastian-Nielsen/better-type-hover",
  enabled = true,
  cond = true,
  ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  config = function()
    require("better-type-hover").setup({
      openTypeDocKeymap = "dK",
    })
  end,
}
