return {
  "nvim-treesitter/nvim-treesitter",
  enabled = true,
  lazy = false,
  build = ":TSUpdate",
  branch = "main",
  dependencies = {
    {
      "daliusd/incr.nvim",
      config = function()
        require("incr").setup({
          incr_key = "<Cr>",
          decr_key = "<Bs>",
        })
      end,
    },
  },
  config = function()
    local map = vim.keymap.set
    map("n", "<leader>tp", "<Cmd>InspectTree<Cr>", { nowait = true })
    local ensure_installed = {
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
    }

    require("nvim-treesitter").install(ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = require("nvim-treesitter.config").get_installed(),
      callback = function(e)
        -- highlight
        pcall(vim.treesitter.start, e.buf, vim.bo.filetype)

        -- folding
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

        -- indentation
        vim.bo[e.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
