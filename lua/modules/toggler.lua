-- Original idea: https://github.com/nguyenvukhang/nvim-toggler

-- Switch the word under cursor to the opposite value with saving case
-- DEMO: true => true, True => False, tRuE => fAlSE
-- (if the opposite word longer when current word,
-- the tail of opposite will be the same case as the last char case of current)

local u = require('utils')
local M = {}

---Every key and value should be in lowercase
local opposites = vim.tbl_add_reverse_lookup({
  ['top'] = 'bottom',
  ['before'] = 'after',
  ['start'] = 'end',
  ['first'] = 'last',
  ['next'] = 'prev',
  ['vim'] = 'emacs',
  ['true'] = 'false',
  ['yes'] = 'no',
  ['on'] = 'off',
  ['left'] = 'right',
  ['up'] = 'down',
  ['split'] = 'join',
  -- TODO: below is not working. Need fix
  ['!='] = '==',
  ['!=='] = '===',
  ['<'] = '>',
})

---Convert string's chars to same case like base string
---If base string length less than target string, other chars will convert to case
---like last char in base string.
---@param base string Base string
---@param str string String to convert
---@return string
local function to_same_register(base, str)
  local base_list = vim.split(base, '', { plain = true })
  local target_list = vim.split(str, '', { plain = true })

  for i, ch in ipairs(target_list) do
    local lower = u.is_lower(base_list[i] or base_list[#base_list])
    target_list[i] = lower and string.lower(ch) or string.upper(ch)
  end

  return table.concat(target_list)
end

---Toggle word (<cword>) under cursor to opposite value.
function M.toggle_word()
  -- Get text under cursor
  local text = vim.fn.expand('<cword>')

  -- Checking if the symbol under cursor is a part of received word
  -- (required to prevent wrong inserting, when cursor at punctuation and whitespace before the target word)
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local char = vim.api.nvim_get_current_line():sub(col, col)
  local contains = string.find(tostring(text), char, 1, true) and true or false

  if text and contains then
    local opp = opposites[string.lower(tostring(text))]

    if opp then
      vim.cmd('normal! "_ciw' .. to_same_register(tostring(text), opp))
    end
  end
end

return M
