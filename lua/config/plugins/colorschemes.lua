local function set_prior(c)
  c = type(c) == "table" and c or { c }
  c.priority = 1000
  return c
end

return vim.tbl_map(set_prior, {
  "yorickpeterse/nvim-grey",
  "Mofiqul/vscode.nvim",
  "dasupradyumna/midnight.nvim",
  "folke/tokyonight.nvim",
  "loctvl842/monokai-pro.nvim",
  "rebelot/kanagawa.nvim",
  "sainnhe/gruvbox-material",
  "sam4llis/nvim-tundra",
  "sho-87/kanagawa-paper.nvim",
  "webhooked/kanso.nvim",
  {
    "Wansmer/serenity.nvim",
    -- dev = false,
    -- dir = "~/projects/code/personal/serenity.nvim",
    name = "serenity",
  },
  { "catppuccin/nvim", name = "catppuccin" },
  { "neanias/everforest-nvim", version = false },
  { "ramojus/mellifluous.nvim", dependencies = { "rktjmp/lush.nvim" } },
  { "rose-pine/neovim", name = "rose-pine" },
})
