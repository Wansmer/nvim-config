return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  keys = {
    {
      "<leader>S",
      function()
        require("persistence").load()
      end,
      desc = "Restore Session",
    },
  },
  enabled = true,
  config = function()
    require("persistence").setup({})
  end,
}
