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

return M
