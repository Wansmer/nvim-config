---Checking if the current line in md - part of list
---@param line string
---@return boolean|string
local function is_md_list(line)
  local list_reg = {
    '^%s*([%-%>%+%*]) ',
    '^%s*(%d+). ',
  }

  for _, reg in ipairs(list_reg) do
    local match = line:match(reg)
    if match then
      return match
    end
  end
  return false
end

-- TODO: разобраться, почему не работает, когда замыкание?

---Adding list prefix to new line if func called on md-list (ol, ul, quote)
---@param cmd string Command to feed
local function conrinue_list_if_need(cmd)
  local line = vim.api.nvim_get_current_line()
  local prefix = is_md_list(line)

  if prefix then
    if tonumber(prefix) then
      prefix = tonumber(prefix) + 1 .. '.'
    end

    cmd = cmd .. prefix .. ' '
  end

  cmd = vim.api.nvim_replace_termcodes(cmd, true, true, true)
  vim.api.nvim_feedkeys(cmd, 'n', false)
end

local map = vim.keymap.set

map('n', 'o', function()
  conrinue_list_if_need('o')
end)

map('n', 'O', function()
  conrinue_list_if_need('O')
end)

map('i', '<S-Cr>', function()
  conrinue_list_if_need('<C-o>o')
end)

map('i', '<Cr>', function()
  conrinue_list_if_need('<C-o>o')
end)
