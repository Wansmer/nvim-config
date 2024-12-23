return {
  "nvim-neotest/neotest",
  enabled = true,
  lazy = true,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
  },
  init = function()
    local map = vim.keymap.set
    map("n", "<leader>nt", function()
      require("neotest").run.run()
    end, { desc = "Run nearest test" })
    map("n", "<leader>nf", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, { desc = "Run current file" })
    map("n", "<leader>no", function()
      require("neotest").output.open({ enter = true })
    end, { desc = "Open test output window" })
  end,
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest"),
      },
    })
  end,
}
