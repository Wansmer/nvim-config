return {
  "Exafunction/codeium.nvim",
  enabled = false,
  event = { "BufReadPre" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  config = function()
    require("codeium").setup({
      manager_path = nil,
      bin_path = vim.fn.stdpath("cache") .. "/codeium/bin",
      config_path = vim.fn.stdpath("cache") .. "/codeium/config.json",
      language_server_download_url = "https://github.com",
      api = {
        host = "server.codeium.com",
        port = "443",
      },
      tools = {},
      wrapper = nil,
    })
  end,
}
