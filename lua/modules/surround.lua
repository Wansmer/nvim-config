local u = require('utils')

local paired = {
  ['"'] = { '"', '"' },
  ["'"] = { "'", "'" },
  ['['] = { '[', ']' },
  ['{'] = { '{', '}' },
  ['('] = { '(', ')' },
  ['<'] = { '< ', ' >' },
  [']'] = { '[ ', ' ]' },
  ['}'] = { '{ ', ' }' },
  [')'] = { '( ', ' )' },
  ['>'] = { '< ', ' >' },
}

local function replace_non_blank(line, side, from, to)
  local pad_l, trim_line, pad_r = u.split_padline(line, side)

  if side == 'left' and vim.startswith(trim_line, from) then
    trim_line = to .. trim_line:sub(#from + 1)
  end

  if side == 'right' and vim.endswith(trim_line, from) then
    trim_line = trim_line:sub(1, -(#from + 1)) .. to
  end

  return vim.fn.join({ pad_l, trim_line, pad_r }, '')
end

local function get_char()
  local ok, char = pcall(vim.fn.getcharstr)
  return ok and char or nil
end

local function change_surround(from, to)
  if paired[from] then
    local from_left, from_right = unpack(paired[from])
    local to_left = paired[to] and paired[to][1] or ''
    local to_right = paired[to] and paired[to][2] or ''
    local cursor = vim.api.nvim_win_get_cursor(0)

    vim.cmd.normal('va' .. from)
    local sr, sc, er, ec = u.to_api_range(u.get_visual_range())

    local lines = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})
    print('Lines:', vim.inspect(lines), 'Range:', sr, sc, er, ec)

    lines[1] = replace_non_blank(lines[1], 'left', from_left, to_left)
    lines[#lines] = replace_non_blank(lines[#lines], 'right', from_right, to_right)

    u.feedkeys('<Esc>')
    vim.api.nvim_buf_set_text(0, sr, sc, er, ec, lines)
    vim.api.nvim_win_set_cursor(0, cursor)
  end
end

local Surround = {}

Surround.replace_surround = change_surround
Surround.remove_surround = change_surround
Surround.add_surround = function(char, is_v)
  if paired[char] then
    local left, right = unpack(paired[char])
    local cursor = vim.api.nvim_win_get_cursor(0)

    local sr, sc, er, ec = u.to_api_range(is_v and u.get_visual_range() or u.get_object_range())
    local lines = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})
    print('Lines:', vim.inspect(lines), 'Range:', sr, sc, er, ec)

    lines[1] = left .. lines[1]
    lines[#lines] = lines[#lines] .. right

    vim.api.nvim_buf_set_text(0, sr, sc, er, ec, lines)
    vim.api.nvim_win_set_cursor(0, cursor)
  end
end

local function register_repeat(name, ...)
  local repeater = '__repeat_' .. name
  local args = { ... }
  _G[repeater] = function()
    Surround[name](unpack(args))
  end
  vim.opt.operatorfunc = 'v:lua.' .. repeater
end

local function call_arg(arg)
  return type(arg) ~= 'function' and arg or arg()
end

local function operatorfunc(name, feed, ...)
  local args = { ... }

  _G['__' .. name] = function()
    local final_args = vim.tbl_map(call_arg, args)
    Surround[name](unpack(final_args))
    register_repeat(name, unpack(final_args))
  end

  return function()
    vim.opt.operatorfunc = 'v:lua.__' .. name
    u.feedkeys(feed)
  end
end

return {
  add = operatorfunc('add_surround', 'g@', get_char),
  add_visual = function()
    Surround.add_surround(get_char(), true)
    u.feedkeys('<Esc>')
  end,
  remove = operatorfunc('remove_surround', 'g@ ', get_char, ''),
  replace = operatorfunc('replace_surround', 'g@ ', get_char, get_char),
}
