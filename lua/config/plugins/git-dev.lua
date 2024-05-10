return {
  "moyiz/git-dev.nvim",
  event = "VeryLazy",
  config = function()
    local gdev = require("git-dev")
    gdev.setup({
      cd_type = "tab",
      opener = function(dir)
        vim.cmd("tabnew")
        vim.cmd("Neotree dir=" .. vim.fn.fnameescape(dir))
      end,
    })

    vim.keymap.set("n", "gx", function()
      local url = vim.fn.expand("<cfile>")
      if not url and url == "" then
        return
      end

      local gdev_path = vim.fn.stdpath("cache") .. "/git-dev"
      local is_gdev = vim.startswith(vim.fn.expand("%:p"), gdev_path)
      local opener = is_gdev and vim.bo.filetype == "markdown" and gdev.open or vim.ui.open
      opener(url)
    end)
  end,
}
