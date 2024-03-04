return {
  "artemave/workspace-diagnostics.nvim",
  enabled = false,
  config = function()
    require("workspace-diagnostics").setup()
  end,
}
