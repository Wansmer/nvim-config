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

function M.get_visual_range()
  local er, ec = unpack(vim.fn.getpos('.'), 2, 3)
  local sr, sc = unpack(vim.fn.getpos('v'), 2, 3)
  local range = {}

  if sr == er then
    local cols = sc >= ec and { ec, sc } or { sc, ec }
    range = { sr, cols[1], er, cols[2] }
  elseif sr > er then
    range = { er, ec, sr, sc }
  else
    range = { sr, sc, er, ec }
  end

  return range
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

return M
