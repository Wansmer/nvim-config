local DEV = false

return {
  "Wansmer/sibling-swap.nvim",
  dir = DEV and "~/projects/code/personal/sibling-swap" or nil,
  dev = DEV,
  enabled = true,
  keys = {
    "<C-.>",
    "<C-,>",
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("sibling-swap").setup({
      highlight_node_at_cursor = true,
      use_default_keymaps = true,
      keymaps = {
        ["<Leader>."] = "swap_with_right",
        ["<Leader>,"] = "swap_with_left",
        ["<C-.>"] = "swap_with_right_with_opp",
        ["<C-,>"] = "swap_with_left_with_opp",
      },
      fallback = {
        tsx = {
          string_fragment = {
            ---@type boolean|function
            enable = function(node)
              -- String should be single line
              local sr, _, er, _ = node:range()
              return sr == er
            end,
            action = function(node, side, _)
              local c = vim.api.nvim_win_get_cursor(0)
              local sr, sc, er, ec = node:range()
              local text = vim.treesitter.get_node_text(node, 0)
              local words = vim.split(text, " ", { trimempty = true })
              local word_idx -- word under cursor
              local count = sc

              for i, word in ipairs(words) do
                count = count + #word + 1
                if count > c[2] then
                  word_idx = i
                  break
                end
              end

              if not word_idx then
                return
              end

              local sib_idx = side == "left" and word_idx - 1 or word_idx + 1
              if not words[sib_idx] then
                return
              end

              local sib = words[sib_idx]
              words[sib_idx], words[word_idx] = words[word_idx], sib

              pcall(vim.api.nvim_buf_set_text, 0, sr, sc, er, ec, { vim.fn.join(words, " ") })
              pcall(vim.api.nvim_win_set_cursor, 0, { c[1], side == "left" and c[2] - #sib - 1 or c[2] + #sib + 1 })
            end,
          },
        },
      },
    })
  end,
}
