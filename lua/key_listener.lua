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
-- NOTE: рассчитана только (!!!) на два символа, потому что больше не надо
-- Проблемы: 1) ставит буфер в modified, даже без изменений, 2) на пустых строках оставляет пробел после <S-S>
local press_esc = (function()
  local prev_char = ''
  local clear_prev = function()
    prev_char = ''
  end

  return function(char)
    local is_escape = prev_char .. char == PREF.common.escape_keys
    local first = vim.split(PREF.common.escape_keys, '', { plain = true })[1]

    if is_escape then
      -- TODO: добавить проверку, что вся строка была пустая, чтобы очищать лишний пробел
      vim.api.nvim_input('<BS><BS><ESC>')
      prev_char = ''
    elseif char == first then
      prev_char = char
      vim.defer_fn(clear_prev, vim.opt.timeoutlen:get())
    end
  end
end)()

local function key_listener(char)
  local key = vim.fn.keytrans(char)
  local mode = vim.fn.mode()
  if mode == 'n' then
    manage_hlsearch(key)
  elseif mode == 'i' then
    press_esc(key)
  end
end

vim.on_key(key_listener, listener_ls)
