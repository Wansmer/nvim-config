local DEV = false

return {
  "Wansmer/neocodeium",
  enabled = true,
  -- cond = not vim.g.vscode,
  cond = false,
  dir = DEV and "~/projects/code/personal/neocodeium" or nil,
  dev = DEV,
  event = "VeryLazy",
  config = function()
    local cdm = require("neocodeium")
    cdm.setup({
      silent = true,
      show_label = false,
      filetypes = {
        DressingInput = false,
        TelescopePrompt = false,
        ["dap-repl"] = false,
      },
    })

    local map = vim.keymap.set

    map("i", "<C-g>", cdm.accept)
    map("i", "<C-.>", function()
      cdm.cycle_or_complete(1)
    end)
    map("i", "<C-,>", function()
      cdm.cycle_or_complete(-1)
    end)

    map("i", "<C-/>", cdm.clear)
    map("i", "<A-.>", cdm.accept_word)
    map("i", "<D-.>", cdm.accept_line)
  end,
}
