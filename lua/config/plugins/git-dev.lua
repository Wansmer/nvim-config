return {
  "moyiz/git-dev.nvim",
  event = "VeryLazy",
  config = function()
    local gdev = require("git-dev")
    gdev.setup({
      cd_type = "tab",
      opener = function(dir)
        local to_open = vim
          .iter({ "READEME.md", "readme.md", "README", "README.txt", "readme.txt" })
          :map(function(f)
            return vim.fs.joinpath(dir, f)
          end)
          :find(function(f)
            return vim.uv.fs_stat(f)
          end)

        local cmd = to_open and "e " .. to_open .. " | Neotree show" or "Neotree dir=" .. dir
        vim.cmd("tabnew | " .. cmd)
      end,
    })

    vim.keymap.set("n", "gx", function()
      local url = vim.fn.expand("<cfile>")
      if not url or url == "" then
        return
      end

      local gdev_path = vim.fn.stdpath("cache") .. "/git-dev"
      local is_gdev = vim.startswith(vim.fn.expand("%:p"), gdev_path)
      local opener = is_gdev and vim.bo.filetype == "markdown" and gdev.open or vim.ui.open
      opener(url)
    end)

    vim.keymap.set("n", "gX", function()
      local url = vim.fn.expand("<cfile>")
      if not url or url == "" then
        return
      end

      vim.ui.select(
        { "Default opener (`vim.ui.open()`)", "GitDev (`git-dev.open()`)" },
        { prompt = "Select opener" },
        function(choice)
          local opener = choice == "GitDev (`git-dev.open()`)" and gdev.open or vim.ui.open
          opener(url)
        end
      )
    end)
  end,
}
