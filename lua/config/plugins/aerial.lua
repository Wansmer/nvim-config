return {
  "stevearc/aerial.nvim",
  enabled = true,
  cond = not vim.g.vscode,
  event = "LspAttach",
  init = function()
    vim.keymap.set("n", "<localleader>v", "<cmd>AerialToggle<CR>")
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- vim.api.nvim_create_autocmd("WinEnter", {
    --   once = true,
    --   callback = function(event)
    --     local ft = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
    --     if ft == "aerial" then
    --       vim.api.nvim_feedkeys(vim.keycode("<C-w>h"), "nit", true)
    --       local left_win = vim.api.nvim_get_current_win()
    --       -- vim.schedule(function()
    --       vim.api.nvim_feedkeys(vim.keycode("<C-w>l"), "nit", true)
    --       -- end)
    --       print('WINDOW "LEFT" IS', left_win)
    --     end
    --   end,
    -- })
    require("aerial").setup({
      backends = {
        ["*"] = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
        markdown = { "treesitter", "markdown" },
      },
      layout = {
        width = 30,
        win_opts = {
          statuscolumn = " ",
          winhl = "Normal:NeoTreeNormal,WinBar:NeoTreeNormal",
        },
      },
      autojump = true,
      post_jump_cmd = "normal! zt",
      show_guides = true,
    })
  end,
}
