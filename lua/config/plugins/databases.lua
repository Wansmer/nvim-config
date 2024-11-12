return {
  { "nanotee/sqls.nvim" },
  {
    "kndndrj/nvim-dbee",
    lazy = false,
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
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true,
      },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      -- vim.g.dbs = {}
    end,
  },
}
