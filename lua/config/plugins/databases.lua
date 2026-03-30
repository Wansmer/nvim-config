return {
  { "nanotee/sqls.nvim" },
  {
    "Wansmer/nvim-dbee",
    lazy = false,
    dir = "~/projects/code/personal/nvim-dbee",
    dev = true,
    dependencies = { "MunifTanjim/nui.nvim" },
    build = function()
      require("dbee").install()
    end,
    config = function()
      local assets = vim.fs.joinpath(vim.fn.stdpath("config")--[[@as string]], "/sql")
      require("dbee").setup({
        editor = {
          directory = assets,
        },
        sources = {
          require("dbee.sources").FileSource:new(vim.fs.joinpath(assets, "persistence.json")),
        },
      })
    end,
  },
}
