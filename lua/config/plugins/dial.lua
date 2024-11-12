return {
  "monaqa/dial.nvim",
  event = "BufReadPre",
  config = function()
    local map = vim.keymap.set
    local action = require("dial.map").manipulate

    map("n", "<C-a>", function()
      action("increment", "normal")
    end)
    map("n", "<C-x>", function()
      action("decrement", "normal")
    end)
    map("n", "g<C-a>", function()
      action("increment", "gnormal")
    end)
    map("n", "g<C-x>", function()
      action("decrement", "gnormal")
    end)
    map("v", "<C-a>", function()
      action("increment", "visual")
    end)
    map("v", "<C-x>", function()
      action("decrement", "visual")
    end)
    map("v", "g<C-a>", function()
      action("increment", "gvisual")
    end)
    map("v", "g<C-x>", function()
      action("decrement", "gvisual")
    end)
  end,
}
