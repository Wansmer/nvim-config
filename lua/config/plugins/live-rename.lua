return {
  "saecki/live-rename.nvim",
  dev = true,
  dir = "~/projects/code/hub/live-rename.nvim",
  enabled = true,
  event = { "LspAttach" },
  config = function()
    require("live-rename").setup({
      keys = {
        cancel = {
          { "i", "<C-[>" },
          { "i", "<C-c>" },
        },
      },
    })
  end,
}
