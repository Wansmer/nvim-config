return {
  "Exafunction/codeium.vim",
  event = "BufReadPre",
  enabled = true,
  config = function()
    vim.g.codeium_idle_delay = 250
    vim.g.codeium_disable_bindings = 1
    vim.g.codeium_no_map_tab = true
    vim.g.codeium_filetypes = {
      -- TODO: Or add trigger mapping to complete?
      ["neo-tree-popup"] = false,
    }
    local map = vim.keymap.set

    map("i", "<C-g>", vim.fn["codeium#Accept"], { expr = true })
    map("i", "<C-j>", vim.fn["codeium#Complete"], { expr = true })
    map("i", "<C-i>", function()
      return vim.fn["codeium#CycleCompletions"](1)
    end, { expr = true })
    map("i", "<c-o>", function()
      return vim.fn["codeium#CycleCompletions"](-1)
    end, { expr = true })
    -- TODO: <C-x> conflict with cmp, find best map
    map("i", "<C-x>", function()
      return vim.fn["codeium#Clear"]()
    end, { expr = true })
  end,
}
