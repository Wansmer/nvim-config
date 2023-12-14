return {
  "SmiteshP/nvim-navic",
  dependencies = "neovim/nvim-lspconfig",
  enabled = false,
  event = "LspAttach",
  config = function()
    require("nvim-navic").setup({
      lsp = {
        auto_attach = true,
      },
      highlight = true,
      separator = " > ",
      depth_limit = 0,
      depth_limit_indicator = "..",
      safe_output = true,
      lazy_update_context = false,
      click = false,
    })
  end,
}
