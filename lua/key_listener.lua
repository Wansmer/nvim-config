local listener_ls = vim.api.nvim_create_namespace('key_listener')

-- Убирает подстветку hlsearch при движении курсора
local function manage_hlsearch(char)
  local keys = { '<CR>', 'n', 'N', '*', '#', '?', '/' }
  if vim.fn.mode() == 'n' then
    local new_hlsearch = vim.tbl_contains(keys, char)
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end

-- Убирает задержку между j и k (или j и j), если они назначены на <esc>
-- NOTE: рассчитана только (!!!) на два символа, потому что больше не надо и для оптимизации
-- Проблемы: 1) ставит буфер в modified, даже без изменений, 2) на пустых строках оставляет пробел после <S-S>
local press_esc = (function()
  local prev_char = ''
  local escape = PREF.common.escape_keys
  local start = vim.fn.strcharpart(escape, 0, 1)
  local end_ = vim.fn.strcharpart(escape, 1, 1)
  -- Или timeoutlen
  local delay = 350
  local clear_prev = function()
    prev_char = ''
  end

  return function(char)
    if char == start then
      prev_char = char
      vim.defer_fn(clear_prev, delay)
    elseif char == end_ and prev_char ~= '' then
      --       ^^^                   ^^^
      -- NOTE: чтобы не выполнять конкатинацию на каждый ввод
      if prev_char .. char == escape then
        -- TODO: добавить проверку на пустую строку
        vim.api.nvim_input('<BS><BS><ESC>')
        prev_char = ''
      end
    end
  end
end)()

local function key_listener(char)
  local key = vim.fn.keytrans(char)
  local mode = vim.fn.mode()
  if mode == 'n' then
    manage_hlsearch(key)
    -- elseif mode == 'i' then
    -- NOTE: неудобств больше, чем удобств
    -- press_esc(key)
  end
end

vim.on_key(key_listener, listener_ls)
