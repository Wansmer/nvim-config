return {
  "nvim-treesitter/nvim-treesitter",
  enabled = true,
  lazy = false,
  config = function()
    local map = vim.keymap.set
    map("n", "tsp", "<Cmd>TSPlaygroundToggle<Cr>")
    map("n", "tsn", "<Cmd>TSNodeUnderCursor<Cr>")
    map("n", "tsh", "<Cmd>TSHighlightCapturesUnderCursor<Cr>")

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
          scope_incremental = "grc",
          node_decremental = "<S-Cr>",
        },
      },

      query_linter = {
        enable = true,
        use_virtual_text = false,
        lint_events = { "BufWrite", "CursorHold" },
      },

      -- TREESITTER PLUGINS
      autopairs = {
        enable = true,
      },

      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = "o",
          toggle_hl_groups = "i",
          toggle_injected_languages = "t",
          toggle_anonymous_nodes = "a",
          toggle_language_display = "I",
          focus_language = "f",
          unfocus_language = "F",
          update = "R",
          goto_node = "<cr>",
          show_help = "?",
        },
      },
    })
  end,
}
