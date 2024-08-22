return {
  "nvim-treesitter/nvim-treesitter",
  enabled = true,
  lazy = false,
  config = function()
    local map = vim.keymap.set
    map("n", "<leader>tp", "<Cmd>InspectTree<Cr>", { nowait = true })
    map("n", "<leader>tn", "<Cmd>TSNodeUnderCursor<Cr>", { nowait = true })
    map("n", "<leader>th", "<Cmd>TSHighlightCapturesUnderCursor<Cr>", { nowait = true })

    require("nvim-treesitter.configs").setup({
      ensure_installed = "all",
      sync_install = false,
      ignore_install = { "phpdoc", "comment" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      -- WARNING: Делает лишний отступ во Vue
      indent = {
        enable = true,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Cr>", -- set to `false` to disable one of the mappings
          node_incremental = "<Cr>",
          node_decremental = "<Bs>",
          scope_incremental = false,
        },
      },

      query_linter = {
        enable = true,
        use_virtual_text = false,
        lint_events = { "BufWrite", "CursorHold" },
      },
    })
  end,
}
