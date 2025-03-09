-- Original idea and knowledge:
--   https://github.com/lukas-reineke/virt-column.nvim
--   https://github.com/xiyaowong/virtcolumn.nvim

-- Lightly variant of setting thin colorcolumn with registry of buffers.
-- If value of colorcolumn like a '+1,+2,+3', all values after first ',' will be ignored.

local NS = vim.api.nvim_create_namespace("__parts.thincc__")
local GR = vim.api.nvim_create_augroup("__parts.thincc__", { clear = true })
local disable_ft = { "alpha", "neo-tree", "toggleterm", "lazy", "lspinfo" }

---Registry for saving original value of colorcolumn of each buffer
local registry = {}

---Using original color for ColorColumn
local color = vim.api.nvim_get_hl(0, { name = "ColorColumn" }).bg
vim.api.nvim_set_hl(0, "ThinCC", { fg = color, default = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Reload color for thincc if colorscheme is changed",
  group = GR,
  callback = function()
    color = vim.api.nvim_get_hl(0, { name = "ColorColumn" }).bg
    vim.api.nvim_set_hl(0, "ThinCC", { fg = color, default = true })
  end,
})

---Calculating target col to set extmark
---@param win integer
---@param bufnr integer
---@return integer|nil
local function calc_colorcolumn_place(win, bufnr)
  local tw = vim.bo[bufnr].textwidth
  local cc = vim.wo[win].colorcolumn

  if cc:match("^[+-]%d+") and tw ~= 0 then
    local shift = vim.tbl_map(vim.trim, vim.split(cc, ",", { plain = true }))[1]
    local col = tw + tonumber(shift)
    return col > 0 and col or nil
  end

  return tonumber(cc)
end

---Get target col to set thin colorcolumn
---@param win integer Current win
---@param bufnr integer Current buffer
---@return integer|nil
local function get_target_column(win, bufnr)
  if not registry[bufnr] then
    registry[bufnr] = { col = calc_colorcolumn_place(win, bufnr) }
  end
  return registry[bufnr].col
end

local function calc_inlayhint_len(mark)
  local len = 0

  for _, value in ipairs(mark or {}) do
    for _, text in ipairs(value[4].virt_text or {}) do
      len = len + #text[1]
    end
  end

  return len
end

---Set or del extmark
---@param bufnr integer Current buffer
---@param line integer
---@param col integer
local function update_exmark(bufnr, line, col)
  local line_text = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
  if vim.fn.type(line_text) == vim.v.t_blob then
    return
  end

  local len = vim.fn.strdisplaywidth(line_text)

  -- Take into account the width of virtual text inlayHint during redrawing
  local ihns = vim.api.nvim_get_namespaces()["nvim.lsp.inlayhint"]
  if ihns then
    local mark = vim.api.nvim_buf_get_extmarks(bufnr, ihns, { line, 0 }, { line + 1, 0 }, { details = true })
    len = len + calc_inlayhint_len(mark or {})
  end

  if not (line_text and len >= col) then
    vim.api.nvim_buf_set_extmark(bufnr, NS, line, 0, {
      id = line + 1,
      virt_text = { { "▕", "ThinCC" } },
      virt_text_pos = "overlay",
      virt_text_win_col = col - 1,
      hl_mode = "combine",
      priority = 0,
    })
  else
    vim.api.nvim_buf_del_extmark(bufnr, NS, line + 1)
  end
end

---Set thin colorcolumn to buffer
local function set_thin_colorcolumn(win, bufnr, topline, botline)
  if vim.tbl_contains(disable_ft, vim.bo[bufnr].filetype) then
    return
  end

  if vim.api.nvim_buf_is_loaded(bufnr) then
    local col = get_target_column(win, bufnr)
    if col then
      vim.wo[win].colorcolumn = ""
      for line = topline, botline, 1 do
        update_exmark(bufnr, line, col)
      end
    end
  end
end

vim.api.nvim_set_decoration_provider(NS, {
  on_win = vim.schedule_wrap(function(_, win, bufnr, topline, botline)
    set_thin_colorcolumn(win, bufnr, topline, botline)
  end),
})
