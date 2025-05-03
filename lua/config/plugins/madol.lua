-- https://gitlab.com/repetitivesin/madol.nvim/-/blob/main/snippet-index.md
return {
  "https://gitlab.com/repetitivesin/madol.nvim",
  ft = { "markdown", "tex", "quarto" },
  dependencies = { "L3MON4D3/LuaSnip", "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("madol").setup()
    local ls = require("luasnip")
    ls.config.setup({
      enable_autosnippets = true,
      store_selection_keys = "<Tab>",
    })
    local map = vim.keymap.set

    map({ "s", "i" }, "<M-j>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      else
        return "<M-j>"
      end
    end, { silent = true })
    map({ "s", "i" }, "<M-k>", function()
      if ls.choice_active() then
        ls.change_choice(-1)
      else
        return "<M-k>"
      end
    end, { silent = true })
    map({ "i", "s" }, "<Tab>", function()
      ls.jump(1)
    end, { silent = true })
    map({ "i", "s" }, "<S-Tab>", function()
      ls.jump(-1)
    end, { silent = true })
  end,
}
