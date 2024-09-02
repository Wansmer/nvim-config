return {
  "MagicDuck/grug-far.nvim",
  enabled = true,
  keys = {
    {
      "<localleader>r",
      function()
        require("grug-far").open()
      end,
      desc = "grug-far: open",
    },
    {
      "<localleader>R",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
      desc = "grug-far: open",
    },
  },
  config = function()
    require("grug-far").setup({})
  end,
}
