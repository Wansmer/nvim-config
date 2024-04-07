local PARTS_NAME = "__parts.mode_clnr__"
local GR = vim.api.nvim_create_augroup(PARTS_NAME, { clear = true })
local NS = vim.api.nvim_create_namespace(PARTS_NAME)

local M = {}

---Make options to override a color group. Take only foreground from %name group
---@param name string Name of base group
---@return vim.api.keyset.highlight
function M.get_fg_from_hl(name)
  local fg = vim.api.nvim_get_hl(0, { name = name }).fg
  local bg = vim.api.nvim_get_hl(0, { name = "CursorLineNr" }).bg
  return { fg = fg, bg = bg, bold = true }
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  vim.api.nvim_create_autocmd("ModeChanged", {
    group = GR,
    callback = function()
      local win = vim.api.nvim_get_current_win()
      local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")
      local override = M.opts.hls[mode] or M.opts.hls.n
      vim.api.nvim_set_hl(NS, "CursorLineNr", override)
      vim.api.nvim_win_set_hl_ns(win, NS)
    end,
  })
end

M.opts = {
  hls = {
    ["n"] = M.get_fg_from_hl("CursorLineNr"),
    ["i"] = M.get_fg_from_hl("String"),
    ["v"] = M.get_fg_from_hl("Statement"),
    ["r"] = M.get_fg_from_hl("Error"),
  },
}

return M
