return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  enabled = true,
  config = function()
    local map = vim.keymap.set
    map("n", "<Leader>gp", ":Gitsigns prev_hunk<CR>", { desc = "Plug Gitsigns: jump to prev hunk" })
    map("n", "<Leader>gn", ":Gitsigns next_hunk<CR>", { desc = "Plug Gitsigns: jump to next hunk" })
    map("n", "<Leader>gs", ":Gitsigns preview_hunk<CR>", { desc = "Plug Gitsigns: preview hunk" })
    map("n", "<Leader>gd", ":Gitsigns diffthis<CR>", { desc = "Plug Gitsigns: open diffmode" })
    map("n", "<Leader>ga", ":Gitsigns stage_hunk<CR>", { desc = "Plug Gitsigns: stage current hunk" })
    map("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Plug Gitsigns: reset current hunk" })
    map("n", "<Leader>gA", ":Gitsigns stage_buffer<CR>", { desc = "Plug Gitsigns: stage current buffer" })
    map("n", "<Leader>gR", ":Gitsigns reset_buffer<CR>", { desc = "Plug Gitsigns: reset current buffer" })

    require("gitsigns").setup({
      signs = {
        --     text = "│",
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = PREF.git.show_signcolumn, -- Toggle with `:Gitsigns toggle_signs`
      current_line_blame = PREF.git.show_blame,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
      },
    })

    -- Fix #563 https://github.com/lewis6991/gitsigns.nvim/issues/563
    -- Add 'CursorLine' background for gitsigns and diagnostic icons
    vim.defer_fn(function()
      local cl_bg = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false }).bg
      local signs = vim.fn.sign_getdefined()
      if signs then
        for _, sign in ipairs(signs) do
          local hl = vim.api.nvim_get_hl(0, { name = sign.texthl, link = false })
          local name = sign.texthl .. "Cul"
          vim.api.nvim_set_hl(0, name, { fg = hl.fg, bg = cl_bg })
          vim.fn.sign_define(sign.name, { culhl = name })
        end
      end
    end, 10)
  end,
}
