return {
  "lukas-reineke/indent-blankline.nvim",
  enabled = vim.g.vscode and false or true,
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  config = function()
    require("ibl").setup({
      indent = { char = "▏" },
      scope = {
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "*oil*",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
          "asm",
        },
      },
    })
  end,
}
