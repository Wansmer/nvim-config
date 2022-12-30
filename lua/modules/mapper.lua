local map = vim.keymap.set

local M = {}

local config = {
  ---@type string
  default_layout = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.',
  ---@type table
  layouts = {
    ---@type string
    ru = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯфисвуапршолдьтщзйкыегмцчнябю',
  },
  ---@type string[] If empty, will remapping for all defaults layouts
  use_layouts = {},
  ---@type boolean
  map_all_ctrl = true,
  force_replace = {
    ---@type string Every <keycode> must be in uppercase
    ['<LOCALLEADER>'] = 'б',
    ['<LEADER>'] = false,
  },
  ---@type table
  system_remap = {
    ru = {
      [':'] = 'Ж',
      [';'] = 'ж',
    },
  },
}

M.config = config

---Setup mapper
---@param opts table
function M.setup(opts)
  opts = opts or {}
  M.config.use_layouts = vim.tbl_keys(M.config.layouts)
  M.config = vim.tbl_deep_extend('force', config, opts)

  if M.config.map_all_ctrl then
    M.set_ctrl()
  end

  M.system_remap()
end

local function trans_keycode(lhs)
  local seq = vim.split(lhs, '', { plain = true })
  local trans_seq = {}
  local ctrl_seq = ''
  local flag = false

  for _, char in ipairs(seq) do
    if char:match('[<>]') then
      flag = not flag and char == '<'
      if flag and char == '>' then
        flag = not flag
      end
    end

    if #ctrl_seq < 3 then
      ctrl_seq = ctrl_seq .. char:upper()
    end

    if flag then
      local c = ctrl_seq == '<C-'
          and vim.fn.tr(char, config.default_layout, config.layouts.ru)
        or string.upper(char)
      table.insert(trans_seq, c)
    else
      table.insert(
        trans_seq,
        vim.fn.tr(char, config.default_layout, config.layouts.ru)
      )
    end
  end

  local tlhs = table.concat(trans_seq, '')

  for key, repl in pairs(config.force_replace) do
    if repl then
      tlhs = tlhs:gsub(key, repl)
    end
  end

  return tlhs
end

function M.set_ctrl()
  local en_list = vim.split(config.default_layout, '', { plain = true })
  for _, char in ipairs(en_list) do
    local modes = { '', '!', 't' }
    local keycode = '<C-' .. char .. '>'
    local tr_keycode = '<C-'
      .. vim.fn.tr(char, config.default_layout, config.layouts.ru)
      .. '>'
    map(modes, tr_keycode, keycode)
  end
end

function M.system_remap()
  for lang, preset in pairs(M.config.system_remap) do
    if vim.tbl_contains(M.config.use_layouts, lang) then
      for key, remap in pairs(preset) do
        map('n', remap, key)
      end
    end
  end
end

function M.trans_dict(dict)
  local trans_tbl = {}
  for key, cmd in pairs(dict) do
    trans_tbl[trans_keycode(key)] = cmd
  end
  return vim.tbl_deep_extend('force', dict, trans_tbl)
end

---Wrapper of vim.keymap.set with same contract
---@param mode string|table Same mode short names as |nvim_set_keymap()|
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping. Can also be a Lua function.
---@param opts table|nil
function M.map(mode, lhs, rhs, opts)
  opts = opts or nil
  -- Default mapping
  map(mode, lhs, rhs, opts)
  -- Translate mapping
  map(mode, trans_keycode(lhs), rhs, opts)
end

return M
