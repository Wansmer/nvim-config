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
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "cuda",
        "dockerfile",
        "editorconfig",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "html",
        "http",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        -- "latex",
        "lua",
        "luadoc",
        "luap", -- luapatterns
        "markdown",
        "markdown_inline",
        "mermaid", -- experimental
        "nginx",
        "python",
        "regex",
        "rust",
        "scss",
        "sql",
        "ssh_config",
        "svelte",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
      sync_install = false,
      ignore_install = { "phpdoc", "comment" },
      auto_install = true,
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
