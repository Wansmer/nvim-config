local PARTS_NAME = "__parts.mode_clnr__"
local GR = vim.api.nvim_create_augroup(PARTS_NAME, { clear = true })

local M = {}

---Make options to override a color group. Take only foreground from %name group
---@param name string Name of base group
---@return vim.api.keyset.highlight
function M.get_fg_from_hl(name)
  local fg = vim.api.nvim_get_hl(0, { name = name }).fg
  local bg = vim.api.nvim_get_hl(0, { name = "CursorLineNr" }).bg
  return { fg = fg, bg = bg, bold = true }
end

M.opts = {
  hls = {
    ["n"] = M.get_fg_from_hl("CursorLineNr"),
    ["i"] = M.get_fg_from_hl("String"),
    ["v"] = M.get_fg_from_hl("Statement"),
    ["r"] = M.get_fg_from_hl("Error"),
  },
}

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  local mode_hl = "ModeCursorLine"
  local alias_pair = "CursorLineNr:" .. mode_hl

  vim.api.nvim_create_autocmd("WinLeave", {
    group = GR,
    callback = function()
      -- Do not change the color of the line number in an inactive window
      vim.wo.winhl = vim
        .iter(vim.split(vim.wo.winhl, ","))
        :filter(function(pair)
          return pair ~= alias_pair
        end)
        :join(",")
    end,
  })

  vim.api.nvim_create_autocmd("ModeChanged", {
    group = GR,
    callback = function()
      if not (vim.wo.number or vim.wo.relativenumber) then
        return
      end

      if not vim.wo.winhl:match(mode_hl) then
        vim.wo.winhl = (vim.wo.winhl == "" and "" or vim.wo.winhl .. ",") .. alias_pair
      end

      local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")
      local override = M.opts.hls[mode] or M.opts.hls.n

      vim.api.nvim_set_hl(0, mode_hl, override)
    end,
  })
end

return M
