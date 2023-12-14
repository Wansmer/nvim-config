require("modules.status.autocmd")
local c = require("modules.status.components")

local M = {}

---See :h 'statuscolumn'
M.statuscolumn = {
  { "%s" },
  { "%=", c.number },
  { " ", c.foldcolumn, " " },
}

---See :h 'statusline'
M.statusline = {
  { c.cur_mode },
  { " ", c.branch, " " },
  { " ", c.filename, "(#%n)" },
  { " ", c.navic, " " },
  { "%=" },
  { c.lsp, " | ", c.formatters, " | ", c.treesitter },
  { " ", "%6.(%l:%c%)", " " },
  { " ", "%4.(%p%%%)", " " },
}

---Join statuscolumn|statusline sections to string
---@param sections table
---@return string
function M.join_sections(sections)
  local res = ""
  for _, section in ipairs(sections) do
    for _, comp in ipairs(section) do
      res = type(comp) == "string" and res .. comp or res .. comp()
    end
  end
  return res
end

---Build string for `statuscolumn`
---@return string
function M.build_stc()
  return vim.v.virtnum < 0 and "" or M.join_sections(M.statuscolumn)
end

---Return value for `statuscolumn`
---@return string
function M.column()
  return '%{%v:lua.require("modules.status").build_stc()%}'
end

---Build string for `statusline`
---@return string
function M.build_stl()
  return M.join_sections(M.statusline)
end

---Return value for `statusline`
---@return string
function M.line()
  return '%{%v:lua.require("modules.status").build_stl()%}'
end

return M
