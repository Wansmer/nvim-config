return {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
  config = function()
    require("flash").setup({
      search = {
        multi_window = false,
        exclude = {
          "notify",
          "cmp_menu",
          "noice",
          "flash_prompt",
          function(win)
            -- exclude non-focusable windows
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
      },
      modes = {
        search = { enabled = true },
        char = { enabled = false },
      },
    })
  end,
}
