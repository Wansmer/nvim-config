return {
  {
    "backdround/pattern-iterator.nvim",
  },
  {
    "backdround/neowords.nvim",
    event = "BufRead",
    config = function()
      local u = require("utils")
      local neowords = require("neowords")
      local map = vim.keymap.set

      local p = neowords.pattern_presets
      local patterns = { p.snake_case, p.camel_case, p.upper_case, p.number, p.hex_color }
      local subword_hops = neowords.get_word_hops(unpack(patterns))

      map({ "n", "x", "o" }, "w", subword_hops.forward_start)
      map({ "n", "x", "o" }, "e", subword_hops.forward_end)
      map({ "n", "x", "o" }, "b", subword_hops.backward_start)
      map({ "n", "x", "o" }, "ge", subword_hops.backward_end)

      local pit = require("pattern-iterator")
      local patt = vim.fn.join({ "\\v(", vim.fn.join(patterns, "\\v|"), "\\v)" }, "")

      --- Set visual selection to current word
      local function select_word()
        local it = pit.new_around(patt, {})
        if not it then
          return
        end

        it:start_position():set_cursor()
        it:start_position():select_region_to(it:end_position())
      end

      ---WARNING: this is not dot-repeatable by default. Not usable for ciw, diw without tune
      ---Run operatror on selected word
      ---@param operator string g, c, y, ~, g~, etc
      ---@return function
      local function action_on_selected(operator)
        return function()
          select_word()
          vim.api.nvim_feedkeys(operator, "ni", false)
        end
      end

      ---Replace selected word with new text
      ---@param lines? string[]
      local function replace_selected(lines)
        lines = lines or { "" }
        select_word()

        local sr, sc, er, ec = u.to_api_range(u.get_visual_range())
        if ec == 1 then
          ec = 0
        end

        vim.api.nvim_buf_set_text(0, sr, sc, er, ec, lines)
        vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nix", false)
      end

      local function ciw()
        action_on_selected("c")()

        vim.api.nvim_create_autocmd("ModeChanged", {
          pattern = "i:*",
          once = true,
          callback = function()
            local text = vim.fn.getreg(".")
            _G["__ciw__"] = vim.schedule_wrap(function()
              u.dot_repeat(true, replace_selected, vim.split(text, "\n"))
            end)

            vim.opt.operatorfunc = "v:lua." .. "__ciw__"
            vim.api.nvim_feedkeys(vim.v.count1 .. "g@l", "nix", true)
          end,
        })
      end

      map("n", "ciw", ciw)
      map("n", "diw", function()
        u.dot_repeat(false, replace_selected)
      end)

      -- Use diW, ciW like default diw, ciw
      map("n", "ciW", "ciw")
      map("n", "diW", "diw")

      map("n", "yiw", action_on_selected("y"))
      map("n", "viw", select_word)
    end,
  },
}
