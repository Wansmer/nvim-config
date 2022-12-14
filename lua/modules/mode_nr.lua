-- Original idea: https://github.com/melkster/modicator.nvim
-- TODO: Changing nr highlight only in the current buffer
-- TODO: Using highlight groups from lualine modes

---Keep original colors of group
local origin_hl = vim.api.nvim_get_hl_by_name('CursorLineNr', true)
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    origin_hl = vim.api.nvim_get_hl_by_name('CursorLineNr', true)
  end,
})

---Get options for overriding color group
---@param name string Name of base group
---@return table
local function get_override(name)
  local hl = vim.api.nvim_get_hl_by_name(name, true)
  return vim.tbl_extend('force', origin_hl, { foreground = hl.foreground })
end

local modes_colors = {
  ['n'] = origin_hl,
  ['i'] = get_override('String'),
  ['v'] = get_override('Keyword'),
  ['r'] = get_override('Error'),
}

---Update highlight group for CursorLineNr considering current mode
local function update_cursorlinenr_hl()
  local num = vim.api.nvim_get_option_value('number', { buf = 0 })
  if num then
    local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub('%W', '')
    local override = modes_colors[mode] or modes_colors.n
    vim.api.nvim_set_hl(0, 'CursorLineNr', override)
  end
end

vim.api.nvim_create_autocmd('ModeChanged', {
  callback = update_cursorlinenr_hl,
})
