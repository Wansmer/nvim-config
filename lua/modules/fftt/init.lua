-- Same as `eyeliner.nvim`, but works with cyrillics

local ns = vim.api.nvim_create_namespace("__parts.fftt__")
local ns_extmark

local M = {}

M.opts = {
  split_by = "[%s%_%-%.]", -- Regex to split by words
  ignore_chars = { "%s", "%p", "%d", "%l", "%u" },
  commands = {
    ["f"] = "left",
    ["F"] = "right",
    ["t"] = "left",
    ["T"] = "right",
  },
  hl_groups = {
    chars = { "Constant", "Text", "WarningMessage" }, -- Set hl for every needed level by order. TODO: implement
    dim = "Comment", -- Set hl for dimmed chars. TODO: implement
  },
}

---@param str string
---@param dir 'left' | 'right'
---@param pos integer
---@return string
function M.prepare_str(str, dir, pos)
  local char_idx = vim.fn.charidx(str, pos)
  if dir == "left" then
    str = vim.fn.strcharpart(str, char_idx + 1)
  else
    str = vim.fn.reverse(vim.fn.strcharpart(str, 0, char_idx))
  end

  return str
end

function M.calc_map(str, dir, pos)
  str = M.prepare_str(str, dir, pos)
  local words = vim.split(str, M.opts.split_by)

  local charlist = {}
  local charlist_counter = {}
  local map = {}

  ---@param chars table
  ---@param counter table
  ---@return table
  local function get_min_frequency_char(chars, counter)
    return vim.iter(chars):skip(1):fold(chars[1], function(acc, char)
      return (counter[acc.char] or 0) <= (counter[char.char] or 0) and acc or char
    end)
  end

  for i, word in ipairs(words) do
    local word_offset = i == 1 and pos + 1 or map[i - 1].offset["end"] + 1
    map[i] = { offset = { start = word_offset, ["end"] = word_offset + #word }, chars = {} }

    for j, char in ipairs(vim.fn.split(word, "\\zs")) do
      local char_offset = j == 1 and map[i].offset.start or map[i].chars[j - 1].offset["end"]

      map[i].chars[j] = {
        index = j,
        char = char,
        offset = { start = char_offset, ["end"] = char_offset + #char },
      }
    end

    if not vim.tbl_isempty(map[i].chars) then
      local min = get_min_frequency_char(map[i].chars, charlist_counter)
      map[i].min = min
      charlist = vim.list_extend(
        charlist,
        vim
          .iter(map[i].chars)
          :map(function(c)
            return c.char
          end)
          :totable()
      )
      charlist_counter = vim.iter(charlist):fold({}, function(acc, char)
        acc[char] = (acc[char] or 0) + 1
        return acc
      end)
    end
  end

  return vim
    .iter(map)
    :skip(1) -- skip first word because the cursor already on it
    :map(function(m)
      if dir == "right" and m.min then
        local start, end_ = m.min.offset.start, m.min.offset["end"]
        m.min.offset.start = pos + 1 - (end_ - pos)
        m.min.offset["end"] = pos + 1 - (start - pos)
      end
      return m.min
    end)
    :totable()
end

function M.set_hl(map)
  local cur = vim.api.nvim_win_get_cursor(0)
  local ns = vim.api.nvim_create_namespace("__parts.fftt.extmark__")
  for _, char in pairs(map) do
    vim.api.nvim_buf_set_extmark(
      0,
      ns,
      cur[1] - 1,
      char.offset.start,
      { end_col = char.offset["end"], hl_group = "Constant" }
    )
  end
  return ns
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
  vim.on_key(function(char)
    if ns_extmark then
      vim.api.nvim_buf_clear_namespace(0, ns_extmark, 0, -1)
      ns_extmark = nil
    end

    if vim.fn.mode() ~= "n" then
      return
    end

    local ok, lm = pcall(require, "langmapper.utils")
    if not ok then
      return
    end

    local key = lm.translate_keycode(vim.fn.keytrans(char), "default", "ru")
    if not M.opts.commands[key] then
      return
    end

    local pos = vim.api.nvim_win_get_cursor(0)[2]
    local str = vim.api.nvim_get_current_line()
    local map = M.calc_map(str, M.opts.commands[key], pos)
    ns_extmark = M.set_hl(map)
    vim.cmd.redraw()
  end, ns)
end

return M
