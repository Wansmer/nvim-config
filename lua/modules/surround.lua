local u = require("utils")

local paired = {
  ['"'] = { '"', '"' },
  ["'"] = { "'", "'" },
  ["`"] = { "`", "`" },
  ["["] = { "[", "]" },
  ["{"] = { "{", "}" },
  ["("] = { "(", ")" },
  ["<"] = { "< ", " >" },
  ["]"] = { "[ ", " ]" },
  ["}"] = { "{ ", " }" },
  [")"] = { "( ", " )" },
  [">"] = { "< ", " >" },
  ["*"] = { "*", "*" },
  ["$"] = { "$", "$" },
}

local function replace_non_blank(line, side, from, to)
  local pad_l, trim_line, pad_r = u.split_padline(line, side)

  if side == "left" and vim.startswith(trim_line, from) then
    trim_line = to .. trim_line:sub(#from + 1)
  end

  if side == "right" and vim.endswith(trim_line, from) then
    trim_line = trim_line:sub(1, -(#from + 1)) .. to
  end

  return vim.fn.join({ pad_l, trim_line, pad_r }, "")
end

local function get_char()
  local ok, char = pcall(vim.fn.getcharstr)
  local ok_lm, lm = pcall(require, "langmapper.utils")
  char = (ok and ok_lm) and lm.translate_keycode(char, "default", "ru") or char
  return ok and char or nil
end

local function change_surround(from, to)
  if paired[from] or from == "t" then
    vim.cmd.normal("va" .. from)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local sr, sc, er, ec = u.to_api_range(u.get_visual_range())
    local lines = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})
    local from_left, from_right, to_left, to_right

    if from == "t" then
      local function extract_tags(lines)
        local str = table.concat(lines, "\n")
        local tags = vim.iter(str:gmatch("<.->"))
        return tags:nth(1), tags:last()
      end

      from_left, from_right = extract_tags(lines)
    else
      from_left, from_right = unpack(paired[from])
    end

    to_left = paired[to] and paired[to][1] or ""
    to_right = paired[to] and paired[to][2] or ""

    lines[1] = replace_non_blank(lines[1], "left", from_left, to_left)
    lines[#lines] = replace_non_blank(lines[#lines], "right", from_right, to_right)

    u.feedkeys("<Esc>", "ni")
    vim.api.nvim_buf_set_text(0, sr, sc, er, ec, lines)
    vim.api.nvim_win_set_cursor(0, cursor)
  end
end
local Surround = {}
Surround.replace_surround = change_surround
Surround.remove_surround = change_surround
Surround.add_surround = function(char, is_v)
  if paired[char] or char == "t" then
    local left, right
    if char == "t" then
      local tag = vim.fn.input("Tag: ")
      left, right = "<" .. tag .. ">", "</" .. tag .. ">"
    else
      left, right = unpack(paired[char])
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local sr, sc, er, ec = u.to_api_range(is_v and u.get_visual_range() or u.get_object_range())
    local lines = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})

    lines[1] = left .. lines[1]
    lines[#lines] = lines[#lines] .. right

    vim.api.nvim_buf_set_text(0, sr, sc, er, ec, lines)
    vim.api.nvim_win_set_cursor(0, cursor)
  end
end

local function register_repeat(name, ...)
  local repeater = "__repeat_" .. name
  local args = { ... }
  _G[repeater] = function()
    Surround[name](unpack(args))
  end
  vim.opt.operatorfunc = "v:lua." .. repeater
end

local function call_arg(arg)
  return type(arg) ~= "function" and arg or arg()
end

local function operatorfunc(name, feed, ...)
  local args = { ... }

  _G["__" .. name] = function()
    local final_args = vim.tbl_map(call_arg, args)
    Surround[name](unpack(final_args))
    register_repeat(name, unpack(final_args))
  end

  return function()
    vim.opt.operatorfunc = "v:lua.__" .. name
    u.feedkeys(feed, "ni")
  end
end

return {
  paired = paired,
  add = operatorfunc("add_surround", "g@", get_char),
  add_visual = function()
    Surround.add_surround(get_char(), true)
    u.feedkeys("<Esc>", "ni")
  end,
  remove = operatorfunc("remove_surround", "g@ ", get_char, ""),
  replace = operatorfunc("replace_surround", "g@ ", get_char, get_char),
  surround = Surround,
}
