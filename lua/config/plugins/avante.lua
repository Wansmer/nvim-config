return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  enabled = true,
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = "gemini_proxy",
    providers = {
      openrouter = {
        __inherited_from = "openai",
        endpoint = "https://openrouter.ai/api/v1",
        api_key_name = "OPENROUTER_API_KEY",
        model = "deepseek/deepseek-chat-v3-0324:free",
      },
      gemini_proxy = {
        __inherited_from = "gemini",
        endpoint = ("%s/v1beta/models/"):format(vim.fn.getenv("GEMINI_PROXY_URL")),
        api_key_name = "GEMINI_API_KEY",
        model = "gemini-2.5-flash-preview-05-20",
      },
    },
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
}
