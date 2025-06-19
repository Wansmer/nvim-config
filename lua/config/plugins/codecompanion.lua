return {
  "olimorris/codecompanion.nvim",
  enabled = true,
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "gemini_proxy",
        },
        inline = {
          adapter = "gemini_proxy",
        },
      },
      adapters = {
        openrouter_ds = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
            schema = {
              model = {
                default = "deepseek/deepseek-chat-v3-0324:free",
              },
            },
          })
        end,
        gemini_proxy = function()
          return require("codecompanion.adapters").extend("gemini", {
            name = "gemini_proxy",
            formatted_name = "Gemini X",
            url = ("%s/v1beta/openai/chat/completions"):format(vim.fn.getenv("GEMINI_PROXY_URL")),
            env = {
              api_key = "GEMINI_API_KEY",
            },
            schema = {
              model = {
                default = "gemini-2.5-flash-preview-05-20",
              },
            },
          })
        end,
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true, -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          },
        },
      },
    })
  end,
}
