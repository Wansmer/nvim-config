local map = vim.keymap.set

local M = {}

local config = {
  ---@type string
  default_layout = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz,.',
  ---@type table
  layouts = {
    ---@type table
    ru = {
      layout = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯфисвуапршолдьтщзйкыегмцчнябю',
      id = 'RussianWin',
    },
  },
  os = {
    Darwin = {
      ---Should return string with id of layouts
      ---@return string
      get_current_layout = function()
        local keyboar_key = '"KeyboardLayout Name"'
        local cmd = 'defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | rg -w '
          .. keyboar_key
        local output = vim.fn.system(cmd)
        local cur_layout =
          vim.trim(output:match('%"KeyboardLayout Name%" = (%a+);'))
        return cur_layout
      end,
    },
  },
  ---@type string[] If empty, will remapping for all defaults layouts
  use_layouts = {},
  ---@type boolean
  map_all_ctrl = true,
  force_replace = {
    ---@type string|boolean Every <keycode> must be in uppercase
    ['<LOCALLEADER>'] = 'б',
    ---@type string|boolean Every <keycode> must be in uppercase
    ['<LEADER>'] = false,
  },
  ---@type table
  system_remap = {
    ru = {
      [':'] = 'Ж',
      [';'] = 'ж',
      ['/'] = '.',
      ['?'] = ',',
    },
  },
}

M.config = config

---Setup mapper
---@param opts? table
function M.setup(opts)
  opts = opts or {}
  M.config.use_layouts = vim.tbl_keys(M.config.layouts)
  M.config = vim.tbl_deep_extend('force', config, opts)

  if M.config.map_all_ctrl then
    M.set_ctrl()
  end

  M.system_remap()
end

local function trans_keycode(lhs, layout)
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
          and vim.fn.tr(char, config.default_layout, layout)
        or string.upper(char)
      table.insert(trans_seq, c)
    else
      table.insert(trans_seq, vim.fn.tr(char, config.default_layout, layout))
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

    for _, lang in ipairs(config.use_layouts) do
      local tr_keycode = '<C-'
        .. vim.fn.tr(char, config.default_layout, config.layouts[lang].layout)
        .. '>'
      map(modes, tr_keycode, keycode)
    end
  end
end

function M.system_remap()
  local function get_current_layout()
    local keyboar_key = '"KeyboardLayout Name"'
    local cmd = 'defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | rg -w '
      .. keyboar_key
    local output = vim.fn.system(cmd)
    local cur_layout =
      vim.trim(output:match('%"KeyboardLayout Name%" = (%a+);'))
    return cur_layout
  end

  local function feed_system(keycode)
    return function()
      local layout = get_current_layout()
      -- TODO:
      if layout == config.layouts.ru.id then
        vim.api.nvim_feedkeys(keycode, 'n', true)
      end
    end
  end

  for lang, preset in pairs(M.config.system_remap) do
    if vim.tbl_contains(M.config.use_layouts, lang) then
      for key, remap in pairs(preset) do
        map('n', remap, feed_system(key))
      end
    end
  end
end

function M.trans_dict(dict)
  local trans_tbl = {}
  for key, cmd in pairs(dict) do
    for _, lang in ipairs(M.config.use_layouts) do
      trans_tbl[trans_keycode(key, M.config.layouts[lang].layout)] = cmd
    end
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
  for _, lang in ipairs(M.config.use_layouts) do
    print('Remap: ', trans_keycode(lhs, M.config.layouts[lang].layout))
    map(mode, trans_keycode(lhs, M.config.layouts[lang].layout), rhs, opts)
  end
end

return M
