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

function M.map()
  local ok, mapper = pcall(require, 'langmapper')
  if ok then
    return mapper.map
  end
  return vim.keymap.set
end

function M.trans_dict(tbl)
  local ok, mapper = pcall(require, 'langmapper.utils')
  if not ok then
    mapper = {}
    mapper.trans_dict = function(x)
      return x
    end
  end
  return mapper.trans_dict(tbl)
end

return M
