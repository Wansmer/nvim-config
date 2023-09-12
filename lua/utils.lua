local M = {}

---Checking if the string in lowercase
---@param str string
---@return boolean
function M.is_lower(str)
  return str == string.lower(str)
end

function M.some(tbl, cb)
  if not vim.tbl_islist(tbl) or vim.tbl_isempty(tbl) then
    return false
  end

  for _, item in ipairs(tbl) do
    if cb(item) then
      return true
    end
  end

  return false
end

function M.list_contains(list, value)
  return M.some(list, function(v)
    return v == value
  end)
end

function M.char_on_pos(pos)
  pos = pos or vim.fn.getpos('.')
  return tostring(vim.fn.getline(pos[1])):sub(pos[2], pos[2])
end

function M.get_object_range()
  local start = vim.api.nvim_buf_get_mark(0, '[')
  local end_ = vim.api.nvim_buf_get_mark(0, ']')
  end_[2] = end_[2] + 1

  return vim.tbl_flatten({ start, end_ })
end

-- From: https://neovim.discourse.group/t/how-do-you-work-with-strings-with-multibyte-characters-in-lua/2437/4
local function char_byte_count(s, i)
  if not s or s == '' then
    return 1
  end

  local char = string.byte(s, i or 1)

  -- Get byte count of unicode character (RFC 3629)
  if char > 0 and char <= 127 then
    return 1
  elseif char >= 194 and char <= 223 then
    return 2
  elseif char >= 224 and char <= 239 then
    return 3
  elseif char >= 240 and char <= 244 then
    return 4
  end
end

function M.get_visual_range()
  local sr, sc = unpack(vim.fn.getpos('v'), 2, 3)
  local er, ec = unpack(vim.fn.getpos('.'), 2, 3)

  -- To correct work with non-single byte chars
  local byte_c = char_byte_count(M.char_on_pos({ er, ec }))
  ec = ec + (byte_c - 1)

  local range = {}

  if sr == er then
    local cols = sc >= ec and { ec, sc } or { sc, ec }
    range = { sr, cols[1] - 1, er, cols[2] }
  elseif sr > er then
    range = { er, ec - 1, sr, sc }
  else
    range = { sr, sc - 1, er, ec }
  end

  return range
end

function M.to_api_range(range)
  local sr, sc, er, ec = unpack(range)
  return sr - 1, sc, er - 1, ec
end

function M.split_padline(line, side)
  side = side or 'both'
  local is_left = side == 'both' and true or side == 'left'
  local is_right = side == 'both' and true or side == 'right'
  local pad_left, pad_right = '', ''

  if is_left then
    local start, end_ = line:find('^%s+')
    if start then
      pad_left = line:sub(start, end_)
      line = line:sub(end_ + 1)
    end
  end

  if is_right then
    local start, end_ = line:find('%s+$')
    if start then
      pad_right = line:sub(start, end_)
      line = line:sub(1, -(#pad_right + 1))
    end
  end

  return pad_left, line, pad_right
end

function M.lazy_rhs_cb(module, cb_name, ...)
  local args = { ... }
  return function()
    if #args == 0 then
      return require(module)[cb_name]()
    else
      return require(module)[cb_name](unpack(args))
    end
  end
end

function M.feedkeys(feed)
  local term = vim.api.nvim_replace_termcodes(feed, true, true, true)
  vim.api.nvim_feedkeys(term, 'n', true)
end

local function system(cmd)
  local output = vim.fn.system(cmd)
  -- To skip no needed terminal messages. Payload is last string.
  local lines = vim.split(vim.trim(output), '\n')
  return lines[#lines]
end

function M.git_status()
  local status = {
    ---@type string Current git branch
    branch = '',
    ---@type string Short name of repo 'User/nameofrepo'
    repo = '',
    ---@type string Remote url of git repo
    remote_url = '',
    ---@type boolean If '.git' exist in current directory
    exist = false,
  }

  local skip = '\\(git@github.com:\\|https:\\/\\/github.com\\/\\|\\.git\\)'

  if vim.loop.fs_stat(vim.loop.cwd() .. '/.git') then
    status.exist = true
    status.branch = system('git branch --show-current')
    status.remote_url = system('git remote get-url --push origin')
    status.repo = vim.fn.substitute(status.remote_url, skip, '', 'g')
  end

  return status
end

function M.current_branch()
  if vim.loop.fs_stat(vim.loop.cwd() .. '/.git') then
    return vim.fn.system('git branch --show-current')
  end
  return ''
end

local function lang_for_range(tree, range)
  for name, child in pairs(tree:children()) do
    if name ~= 'comment' and child:contains(range) then
      return vim.tbl_isempty(child:children()) and name or lang_for_range(child, range)
    end
  end
  return tree:lang()
end

function M.get_lang()
  local lang = vim.bo.filetype
  local ts_ok, parsers = pcall(require, 'nvim-treesitter.parsers')

  if ts_ok then
    local cur = vim.api.nvim_win_get_cursor(0)
    local indent = vim.fn.indent(cur[1])
    if cur[2] < indent then
      cur[2] = cur[2] + indent
    end
    local range = { cur[1] - 1, cur[2], cur[1] - 1, cur[2] }
    local lang_tree = parsers.get_parser()
    lang = lang_for_range(lang_tree, range)
  end

  return lang
end

---Bind arguments to callback
---@param cb function callback to invoke
---@vararg ...any
function M.bind(cb, ...)
  local args = { ... }
  return function()
    if #args == 0 then
      cb()
    else
      cb(unpack(args))
    end
  end
end

return M
