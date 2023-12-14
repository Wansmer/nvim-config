return {
  "saecki/crates.nvim",
  enabled = false,
  event = { "BufRead Cargo.toml" },
  requires = {
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    require("crates").setup({})
  end,
}
