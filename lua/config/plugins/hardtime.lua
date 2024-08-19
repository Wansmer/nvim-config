return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  enabled = false,
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  config = function()
    require("hardtime").setup({
      disable_mouse = false,
      debug = false,
      restricted_keys = {
        ["<C-P>"] = {},
        ["<C-N>"] = {},
      },
    })
  end,
}
