return {
  "linux-cultist/venv-selector.nvim",
  branch = "regexp",
  ft = { "python" },
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("venv-selector").setup()
  end,
}
