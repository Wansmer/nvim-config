-- Original idea and knowledge:
-- https://github.com/lukas-reineke/virt-column.nvim
-- https://github.com/xiyaowong/virtcolumn.nvim

-- Lightly variant of setting thin colorcolumn with registry of buffers.
-- If value of colorcolumn like a '+1,+2,+3', all values after first ',' will be ignored.

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
  }
end

local function get_registry_key(buf)
  local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
  return ft .. buf
end

local function update_registry(buf, col)
  local key = get_registry_key(buf)
  if not registry[key] then
    registry[key] = { col = col }
  end
end

local function calc_colorcolumn_place(scope)
  local tw = vim.api.nvim_get_option_value('textwidth', scope)
  local cc = vim.api.nvim_get_option_value('colorcolumn', scope)
  local opts = { plain = true }

  if cc:match('^[+-]%d+') and tw ~= 0 then
    local shift = tonumber(vim.tbl_map(vim.trim, vim.split(cc, ',', opts))[1])
    local col = tw + shift
    return col > 0 and col or nil
  end

  return tonumber(cc)
end

local function get_col(bufnr)
  local key = get_registry_key(bufnr)

  if not registry[key] then
    local win = vim.api.nvim_get_current_win()
    local scope = { scope = 'local', win = win }
    local col = calc_colorcolumn_place(scope)

    if col then
      vim.api.nvim_set_option_value('colorcolumn', '', scope)
    end

    update_registry(bufnr, col)
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
