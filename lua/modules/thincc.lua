-- Original idea and knowledge:
-- https://github.com/lukas-reineke/virt-column.nvim
-- https://github.com/xiyaowong/virtcolumn.nvim

-- Light and lazy variant of setting thin colorcolumn with registry of buffers.
-- No work with textwidth and colorcolumn like '+2' or '-1'

local tccns = vim.api.nvim_create_namespace('thincc')
local group = vim.api.nvim_create_augroup('thincc', { clear = true })
local events = { 'BufWinEnter', 'TextChangedI', 'TextChanged' }

local color = vim.api.nvim_get_hl_by_name('ColorColumn', true).background
vim.api.nvim_set_hl(0, 'ThinCC', { fg = color, default = true })

local registry = {}

local function get_col_data(col)
  return {
    virt_text = { { '▕', 'ThinCC' } },
    virt_text_pos = 'overlay',
    virt_text_win_col = col - 1,
    hl_mode = 'combine',
    priority = 1,
  }
end

local function get_registry_key(buf)
  local ft = vim.api.nvim_get_option_value('ft', { buf = buf })
  return ft .. buf
end

local function update_registry(buf, cc, col)
  local key = get_registry_key(buf)
  if not registry[key] then
    registry[key] = { start_cc = cc, col = col }
  end
end

local function get_col(bufnr)
  local key = get_registry_key(bufnr)
  if not registry[key] then
    local win = vim.api.nvim_get_current_win()
    local scope = { scope = 'local', win = win }
    local cc = vim.api.nvim_get_option_value('colorcolumn', scope)
    local col = tonumber(cc)
    if col then
      vim.api.nvim_set_option_value('colorcolumn', '', scope)
    end
    update_registry(bufnr, cc, col)
  end
  return registry[key].col
end

local function set_thin_colorcolumn()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_is_loaded(bufnr) then
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local col = get_col(bufnr)
    if col then
      for line = 0, line_count, 1 do
        vim.api.nvim_buf_set_extmark(bufnr, tccns, line, 0, get_col_data(col))
      end
    end
  end
end

vim.api.nvim_create_autocmd(events, {
  group = group,
  callback = set_thin_colorcolumn,
})
