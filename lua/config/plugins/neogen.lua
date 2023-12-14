return {
  "danymat/neogen",
  enabled = true,
  cmd = "Neogen",
  keys = { "<localleader>a" },
  config = function()
    vim.keymap.set("n", "<localleader>a", ":Neogen<CR>")
    require("neogen").setup({
      snippet_engine = "luasnip",
      languages = {
        lua = {
          template = {
            annotation_convention = "emmylua",
          },
        },
      },
    })
  end,
}
