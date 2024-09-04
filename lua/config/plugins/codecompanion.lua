return {
  "olimorris/codecompanion.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = { adapter = "ollama" },
        inline = { adapter = "ollama" },
        agent = { adapter = "ollama" },
      },
      server = { url = "127.0.0.1:11434" },
      model = "codegemma",
    })
  end,
}
