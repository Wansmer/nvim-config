local u = require("utils")
local ok, lm = pcall(require, "langmapper")
if not ok then
  return
end

local lm_utils = require("langmapper.utils")

local layouts = {
  ["com.apple.keylayout.ABC"] = "default",
  ["com.apple.keylayout.RussianWin"] = "ru",
}

_G.__last_insert_range = {}
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = function(e)
    local cur = vim.api.nvim_win_get_cursor(0)
    _G.__last_insert_range = { cur[1] - 1, cur[2], cur[1] - 1, cur[2] }
  end,
})

vim.api.nvim_create_autocmd({ "TextChangedI" }, {
  callback = function(e)
    local cur = vim.api.nvim_win_get_cursor(0)
    -- Update range on new line
    if _G.__last_insert_range[1] ~= cur[1] - 1 then
      _G.__last_insert_range[1] = cur[1] - 1
      _G.__last_insert_range[2] = cur[2]
      _G.__last_insert_range[3] = cur[1] - 1
    end

    _G.__last_insert_range[4] = cur[2]
  end,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinLeave" }, {
  callback = function(e)
    _G.__last_insert_range = {}
  end,
})

---Switch recently inserted text or selected text to the opposite layout
---WARNING:  While works for text on the same line and when cursor at the end of the selected text
---@param range number[] - start row, start col, end row, end col
local function switch_range_layout(range)
  local sr, sc, er, ec = range[1], range[2], range[3], range[4]

  if sr ~= er or sc == ec then
    return
  end

  local from, to = u.layout.toggle()
  local text = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})[1]
  local tr_text = lm_utils.translate_keycode(text, layouts[to], layouts[from])
  local cursor = vim.api.nvim_win_get_cursor(0)

  -- 'ec' is not used because need to consider the length in bytes
  local ok_set_text, err = pcall(vim.api.nvim_buf_set_text, 0, sr, sc, er, sc + #text, { tr_text })
  if not ok_set_text then
    vim.notify(err or "", vim.log.levels.WARN)
    return
  end

  if #text ~= #tr_text then
    local shift = vim.fn.mode() == "v" and -1 or 0 -- fix cursor position in visual mode
    vim.api.nvim_win_set_cursor(0, { cursor[1], sc + #tr_text + shift })
  end
end

lm.map({ "i" }, "<C-m>", function()
  switch_range_layout(_G.__last_insert_range)
end)

lm.map({ "i" }, "<A-m>", function()
  local sr, sc, er, ec = unpack(_G.__last_insert_range)
  local text = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})[1]
  local words = vim.split(text, "[%s%p]")
  switch_range_layout({ sr, ec - #words[#words], er, ec })
end)

lm.map({ "v" }, "<C-m>", function()
  local range = u.get_visual_range()
  switch_range_layout({ range[1] - 1, range[2], range[3] - 1, range[4] })
end)

lm.map("c", "<A-m>", function()
  local cmd = vim.fn.getcmdline()
  local from, to = u.layout.toggle()
  cmd = lm_utils.translate_keycode(cmd, layouts[to], layouts[from])
  vim.fn.setcmdline(cmd)
  vim.cmd.redraw()
end)
