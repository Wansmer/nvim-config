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

return M
