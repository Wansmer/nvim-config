-- Original idea and knowledge: https://github.com/lukas-reineke/virt-column.nvim
-- https://github.com/xiyaowong/virtcolumn.nvim

-- Lightly variant of setting thin colorcolumn with registry of buffers.
-- If value of colorcolumn like a '+1,+2,+3', all values after first ',' will be ignored.
-- TODO: rewrite with 'nvim_buf_attach': redraw only when line count are changed or current line is bigger than colorcolumn

local tccns = vim.api.nvim_create_namespace('thincc')
local group = vim.api.nvim_create_augroup('thincc', { clear = true })
local events = { 'ColorScheme', 'BufWinEnter', 'TextChangedI', 'TextChanged', 'FileChangedShellPost' }
local disable_ft = {
  '', -- e.g. popups and other windows without filetype
  'alpha',
  'neo-tree',
  'toggleterm',
  'lazy',
  'lspinfo',
  'null-ls-info',
}

---Registry for saving original value of colorcolumn of each buffer
local registry = {}

---Using original color for ColorColumn
-- local color = vim.api.nvim_get_hl_by_name('ColorColumn', true).background
local color = vim.api.nvim_get_hl(0, { name = 'ColorColumn' }).bg

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Reload color for thincc if colorscheme is changed',
  callback = function()
    color = vim.api.nvim_get_hl(0, { name = 'ColorColumn' }).bg
    vim.api.nvim_set_hl(0, 'ThinCC', { fg = color, default = true })
  end,
})

vim.api.nvim_set_hl(0, 'ThinCC', { fg = color, default = true })

---Create extmark
---@param id integer Id for extmark
---@param col integer Target col to set extmark
---@return table
local function create_extmark(id, col)
  return {
    id = id,
    virt_text = { { '▕', 'ThinCC' } },
    virt_text_pos = 'overlay',
    virt_text_win_col = col - 1,
    hl_mode = 'combine',
  }
end

---Create unique key for buffers registry (buf num + filetype)
---@param buf integer Number of buffer
---@return string
local function make_registry_key(buf)
  local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
  return ft .. buf
end

---Add new value to registry if it don't exist
---@param buf integer Number of buffer
---@param col integer|nil Original value of colorcolumn or nil for disable buffer
local function update_registry(buf, col)
  local key = make_registry_key(buf)
  if not registry[key] then
    registry[key] = { col = col }
  end
end

---Calculating target col to set extmark
---@param scope table { scope = 'local' }
---@return integer|nil
local function calc_colorcolumn_place(scope)
  local tw = vim.api.nvim_get_option_value('textwidth', scope)
  local cc = vim.api.nvim_get_option_value('colorcolumn', scope)

  if cc:match('^[+-]%d+') and tw ~= 0 then
    local shift = vim.tbl_map(vim.trim, vim.split(cc, ',', { plain = true }))[1]
    local col = tw + tonumber(shift)
    return col > 0 and col or nil
  end

  return tonumber(cc)
end

---Get target col to set thin colorcolumn
---@param bufnr integer Current buffer
---@return integer|nil
local function get_target_column(bufnr)
  local key = make_registry_key(bufnr)

  if not registry[key] then
    local scope = { scope = 'local' }
    local col = calc_colorcolumn_place(scope)

    update_registry(bufnr, col)
  end

  return registry[key].col
end

local function collect_ih_len(mark)
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
  local c_line = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
  local len = vim.fn.strdisplaywidth(c_line)

  -- Take into account the width of virtual text inlayHint during redrawing
  local ihns = vim.api.nvim_get_namespaces()['vim_lsp_inlayhint']
  if ihns then
    local mark = vim.api.nvim_buf_get_extmarks(bufnr, ihns, { line, 0 }, { line + 1, 0 }, { details = true })
    len = len + collect_ih_len(mark or {})
  end

  if not (c_line and len >= col) then
    local extmark = create_extmark(line + 1, col)
    vim.api.nvim_buf_set_extmark(bufnr, tccns, line, 0, extmark)
  else
    vim.api.nvim_buf_del_extmark(bufnr, tccns, line + 1)
  end
end

---Set thin colorcolumn to buffer
local function set_thin_colorcolumn()
  local ft = vim.api.nvim_buf_get_option(0, 'filetype')

  if vim.tbl_contains(disable_ft, ft) then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_loaded(bufnr) then
    local count = vim.api.nvim_buf_line_count(bufnr)
    local col = get_target_column(bufnr)
    if col then
      local win = vim.api.nvim_get_current_win()
      local scope = { win = win, scope = 'local' }

      vim.api.nvim_set_option_value('colorcolumn', '', scope)

      for line = 0, count, 1 do
        update_exmark(bufnr, line, col)
      end
    end
  end
end

vim.api.nvim_create_autocmd(events, {
  group = group,
  callback = set_thin_colorcolumn,
})

vim.api.nvim_create_autocmd('OptionSet', {
  group = group,
  pattern = 'colorcolumn',
  callback = set_thin_colorcolumn,
})

-- Redraw thincc when inlayHint setted
vim.api.nvim_create_autocmd('LspRequest', {
  group = group,
  callback = function(e)
    local req = e.data.request
    if req.method == 'textDocument/inlayHint' and req.type == 'complete' then
      set_thin_colorcolumn()
    end
  end,
})
