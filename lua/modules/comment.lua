local u = require('utils')

local function get_comment_pattern()
  local lang = u.get_lang()
  local cs = tostring(vim.filetype.get_option(lang, 'commentstring'))
  return vim.split(cs, '%s', { plain = true })
end

local function comment(line)
  local cs = tostring(vim.filetype.get_option(u.get_lang(), 'commentstring'))
  return cs:format(line)
end

local function uncomment(line)
  local patterns = get_comment_pattern()
  local pad, cut_line = u.split_padline(line, 'left')

  if vim.startswith(cut_line, patterns[1]) then
    cut_line = cut_line:sub(#patterns[1] + 1)
  end

  if #patterns[2] ~= 0 and vim.endswith(cut_line, patterns[2]) then
    cut_line = cut_line:sub(1, -(#patterns[2] + 1))
  end

  return pad .. cut_line
end

local function is_commented(line)
  line = vim.trim(line)
  local patterns = get_comment_pattern()
  local prefix, postfix = unpack(patterns)
  return vim.startswith(line, vim.trim(prefix)) and vim.endswith(line, vim.trim(postfix))
end

local function min_indent(start, end_, lines)
  local min = vim.fn.indent(start)
  local i = 1
  while start <= end_ do
    if vim.trim(lines[i]) ~= '' then
      local indent = vim.fn.indent(start)
      min = min <= indent and min or indent
    end
    start = start + 1
    i = i + 1
  end
  return min
end

_G.__comment = function(method)
  local is_v = method == 'visual'
  local patterns = get_comment_pattern()
  if not vim.tbl_isempty(patterns) then
    local sr, _, er, _ = u.to_api_range(is_v and u.get_visual_range() or u.get_object_range())

    local lines = vim.api.nvim_buf_get_lines(0, sr, er + 1, true)
    local mode = is_commented(lines[1]) and 'uncomment' or 'comment'
    local indent = mode == 'comment' and min_indent(sr + 1, er + 1, lines) or 0

    local processed_lines = {}

    for i, line in ipairs(lines) do
      line = line:sub(indent + 1)
      line = mode == 'comment' and comment(line) or uncomment(line)
      processed_lines[i] = (' '):rep(indent) .. line
    end

    vim.api.nvim_buf_set_lines(0, sr, er + 1, true, processed_lines)
  end
end

local function comment_repeat(motion)
  motion = motion or ''
  return function()
    vim.opt.operatorfunc = 'v:lua.__comment'
    return 'g@' .. motion
  end
end

return {
  toggle_line = comment_repeat(' '),
  toggle_object = comment_repeat(),
  toggle_visual = function()
    _G.__comment('visual')
  end,
}
