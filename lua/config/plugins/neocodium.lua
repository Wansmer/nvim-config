return {
  "monkoose/neocodeium",
  event = "VeryLazy",
  config = function()
    local neocodeium = require("neocodeium")
    neocodeium.setup({
      silent = true,
    })
    local map = vim.keymap.set
    map("i", "<C-g>", neocodeium.accept)
    map("i", "<C-.>", function()
      neocodeium.cycle_or_complete(1)
    end)
    map("i", "<C-,>", function()
      neocodeium.cycle_or_complete(-1)
    end)
  end,
}
