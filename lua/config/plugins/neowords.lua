return {
  {
    "backdround/pattern-iterator.nvim",
  },
  {
    "backdround/neowords.nvim",
    event = "BufRead",
    config = function()
      local neowords = require("neowords")

      local p = neowords.pattern_presets

      local patterns = { p.snake_case, p.camel_case, p.upper_case, p.number, p.hex_color }

      local subword_hops = neowords.get_word_hops(unpack(patterns))
      local map = vim.keymap.set

      map({ "n", "x", "o" }, "w", subword_hops.forward_start)
      map({ "n", "x", "o" }, "e", subword_hops.forward_end)
      map({ "n", "x", "o" }, "b", subword_hops.backward_start)
      map({ "n", "x", "o" }, "ge", subword_hops.backward_end)

      local pit = require("pattern-iterator")
      local patt = vim.fn.join({ "\\v(", vim.fn.join(patterns, "\\v|"), "\\v)" }, "")

      local function set_visual()
        local it = pit.new_around(patt, {})
        if not it then
          return
        end

        it:start_position():set_cursor()
        it:start_position():select_region_to(it:end_position())
      end

      local function with_opp(opp)
        return function()
          set_visual()
          vim.api.nvim_feedkeys(opp, "n", false)
        end
      end

      -- TODO: make it dot-repeatable
      map("n", "ciw", with_opp("c"))
      map("n", "diw", with_opp("d"))

      -- Use diW, ciW like default diw, ciw
      map("n", "ciW", "ciw")
      map("n", "diW", "diw")

      map("n", "yiw", with_opp("y"))
      map("n", "viw", set_visual)
    end,
  },
}
