local u = require("utils")

---Checking if the current line in md - part of list
---@param line string
---@return boolean|string returned false if not a list or marker of matching list if it a list
local function is_list(line)
  local list_reg = {
    "^%s*(%-%s%[.%]) ", -- "- [ ]"
    "^%s*([%-%>%+%*]) ", -- "-", ">", "+", "*",
    "^%s*(%d+). ",
    "^%s*(%w)%. ",
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
  return tonumber(mark) or mark:match("%w")
end

---Return next marker for ordered list
---@param mark string
---@param operand 1|-1|0
local function get_next_mark(mark, operand)
  if tonumber(mark) then
    return tonumber(mark) + operand
  else
    local ab = "abcdefghijklmnopqrstuvwxyz"
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
  -- TODO: add normal checks for "- [ ]". No hardcode
  if not vim.startswith(mark, "- [") and is_ol(mark) then
    action = action or "i"
    local actions = { i = 1, d = -1, e = 0 }
    mark = get_next_mark(mark, actions[action]) .. "."
  end
  return mark .. " "
end

---Adding list prefix to new line if func called on md-list (ol, ul, quote)
---TODO: разобраться, почему не работает, когда замыкание?
---@param cmd string Command to feed
---@param action? 'i'|'d'|'e' 'i' - increment (default), 'd' - decrement, 'e' - equal (use only fo ordered list)
local function continue_list_if_need(cmd, action)
  local line = vim.api.nvim_get_current_line()
  local marker = is_list(line)
  print(marker)

  if marker then
    marker = update_prefix(tostring(marker), action)
    cmd = cmd .. marker
  end

  cmd = vim.api.nvim_replace_termcodes(cmd, true, true, true)
  vim.api.nvim_feedkeys(cmd, "n", false)
end

-- Surrounder: surround text for bold, italic and link template in charwise visual mode
-- Original idea: https://github.com/antonk52/markdowny.nvim
-- My implementation: https://github.com/antonk52/markdowny.nvim/issues/1#issuecomment-1382060417

local function surround(prefix, postfix, range, text)
  local sr, sc, er, ec

  if range then
    sr, sc, er, ec = unpack(range)
  else
    sr, sc, er, ec = u.to_api_range(u.get_visual_range())
  end

  if not text then
    text = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})
  end

  text[1] = prefix .. text[1]
  text[#text] = text[#text] .. postfix

  u.feedkeys("<Esc>")
  vim.api.nvim_buf_set_text(0, sr, sc, er, ec, text)
end

local function surround_link()
  local range = { u.to_api_range(u.get_visual_range()) }
  local reg = vim.fn.getreg("*")
  local default = false
  local text = vim.api.nvim_buf_get_text(0, range[1], range[2], range[3], range[4], {})

  -- TODO: find better way to check urls and paths
  local re = vim.regex("^https*\\|www")
  if type(reg) == "string" and re and re:match_str(reg) then
    default = true
  end

  vim.ui.input({
    prompt = "Link:",
    default = default and reg or nil, -- Paste reg * if it contains url
  }, function(link)
    if not link then
      return
    end
    surround("[", "](" .. link .. ")", range, text)
  end)
end

local map = vim.keymap.set

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.md",
  callback = function()
    local buffer = vim.api.nvim_get_current_buf()
    map("n", "o", function()
      continue_list_if_need("o")
    end, { buffer = buffer })

    map("n", "O", function()
      continue_list_if_need("O", "d")
    end, { buffer = buffer })

    map("i", "<Cr>", function()
      continue_list_if_need("<Cr>")
    end, { buffer = buffer })

    map("x", "<C-b>", function()
      surround("**", "**")
    end, { buffer = buffer })

    map("x", "<C-i>", function()
      surround("_", "_")
    end, { buffer = buffer })

    map("x", "<C-k>", surround_link, { buffer = buffer })
  end,
})
