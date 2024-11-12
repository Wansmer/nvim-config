return {
  "Vigemus/iron.nvim",
  keys = {
    { "<leader>tr", vim.cmd.IronRepl, desc = "󱠤 Toggle REPL" },
    { "<leader>rr", vim.cmd.IronRestart, desc = "󱠤 Restart REPL" },
    { "<leader>u", mode = { "n", "x" }, desc = "󱠤 Send-to-REPL Operator" },
  },
  config = function()
    require("iron.core").setup({
      keymaps = {
        send_line = "<leader>u",
        visual_send = "<leader>u",
      },
      config = {
        repl_open_cmd = "horizontal bot 20 split",
        repl_definition = {
          python = {
            command = function()
              local ipythonAvailable = vim.fn.executable("ipython") == 1
              local binary = ipythonAvailable and "ipython" or "python3"
              return { binary }
            end,
          },
        },
      },
    })
  end,
}
