return {
  "supermaven-inc/supermaven-nvim",
  enabled = true,
  event = "BufReadPre",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<C-g>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
    })
  end,
}
