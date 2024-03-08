local PARTS_NAME = "__parts.mode_clnr__"
local GR = vim.api.nvim_create_augroup(PARTS_NAME, { clear = true })
local NS = vim.api.nvim_create_namespace(PARTS_NAME)

---Make options to override a color group. Take only foreground from %name group
---@param name string Name of base group
---@return vim.api.keyset.highlight
local function make_override_hl(name)
  local hl = vim.api.nvim_get_hl(0, { name = name })
  return vim.tbl_extend("force", {}, { fg = hl.fg, bold = true })
end

local modes = {
  ["n"] = make_override_hl("CursorLineNr"),
  ["i"] = make_override_hl("String"),
  ["v"] = make_override_hl("Statement"),
  ["r"] = make_override_hl("Error"),
}

---Update highlight group for CursorLineNr considering current mode in current window
local function update_cursorlinenr_hl()
  local win = vim.api.nvim_get_current_win()
  local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")
  local override = modes[mode] or modes.n
  vim.api.nvim_set_hl(NS, "CursorLineNr", override)
  vim.api.nvim_win_set_hl_ns(win, NS)
end

vim.api.nvim_create_autocmd("ModeChanged", {
  group = GR,
  callback = update_cursorlinenr_hl,
})
