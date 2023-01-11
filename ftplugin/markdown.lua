local u = require('utils')

---Checking if the current line in md - part of list
---@param line string
---@return boolean|string returned false if not a list or marker of matching list if it a list
local function is_list(line)
  local list_reg = {
    '^%s*([%-%>%+%*]) ',
    '^%s*(%d+). ',
    '^%s*(%w). ',
  }

  for _, reg in ipairs(list_reg) do
    local match = line:match(reg)
    if match then
      return match
    end
  end

  return false
end

---Checking if the current list is ordered
---@param mark string marker of list
---@return boolean
local function is_ol(mark)
  return tonumber(mark) or mark:match('%w')
end

---Return next marker for ordered list
---@param mark string
---@param operand 1|-1|0
local function get_next_mark(mark, operand)
  if tonumber(mark) then
    return tonumber(mark) + operand
  else
    local ab = 'abcdefghijklmnopqrstuvwxyz'
    local next_i = ab:find(mark:lower()) + operand
    if #ab >= next_i then
      local n_mark = ab:sub(next_i, next_i)
      mark = u.is_lower(mark) and n_mark or n_mark:upper()
    end
    return mark
  end
end

---Updated prefix for add to new string
---@param mark string
---@param action? 'i'|'d'|'e' 'i' - increment (default), 'd' - decrement, 'e' - equal (use only fo ordered list)
---@return string
local function update_prefix(mark, action)
  if is_ol(mark) then
    action = action or 'i'
    local actions = { i = 1, d = -1, e = 0 }
    mark = get_next_mark(mark, actions[action]) .. '.'
  end
  return mark .. ' '
end

---Adding list prefix to new line if func called on md-list (ol, ul, quote)
---TODO: разобраться, почему не работает, когда замыкание?
---@param cmd string Command to feed
---@param action? 'i'|'d'|'e' 'i' - increment (default), 'd' - decrement, 'e' - equal (use only fo ordered list)
local function continue_list_if_need(cmd, action)
  local line = vim.api.nvim_get_current_line()
  local marker = is_list(line)

  if marker then
    marker = update_prefix(marker, action)
    cmd = cmd .. marker
  end

  cmd = vim.api.nvim_replace_termcodes(cmd, true, true, true)
  vim.api.nvim_feedkeys(cmd, 'n', false)
end

local map = vim.keymap.set

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.md',
  callback = function()
    local buffer = vim.api.nvim_get_current_buf()
    map('n', 'o', function()
      continue_list_if_need('o')
    end, { buffer = buffer })

    map('n', 'O', function()
      continue_list_if_need('O', 'd')
    end, { buffer = buffer })

    map('i', '<Cr>', function()
      continue_list_if_need('<Cr>')
    end, { buffer = buffer })
  end,
})
