return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  enabled = true,
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("hardtime").setup({
      debug = false,
      restricted_keys = {
        ["<C-P>"] = {},
        ["<C-N>"] = {},
      },
    })
  end,
}
