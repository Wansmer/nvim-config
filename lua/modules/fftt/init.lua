-- Same as `eyeliner.nvim`, but works with cyrillics

local ns = vim.api.nvim_create_namespace("__parts.fftt__")
local get_hl = vim.api.nvim_get_hl
local set_hl = vim.api.nvim_set_hl

local M = {}
M.ns_extmark = nil

M.opts = {
  split_by = "[%s%_%-%@]", -- Regex to split by words
  ignore_chars = { "%s", "%p", "%d", "%l", "%u" },
  commands = { ["f"] = "left", ["F"] = "right", ["t"] = "left", ["T"] = "right" },
  hl_groups = {
    chars = { "FFTTLever1", "FFTTLever2", "FFTTLever3" }, -- Set hl for every needed level by order.
    dim = "", -- Set hl for dimmed chars, e.g. dim = "Comment"
  },
}

---@param str string
---@param dir 'left' | 'right'
---@param pos integer
---@return string
function M.prepare_str(str, dir, pos)
  local idx = vim.fn.charidx(str, pos)
  local sub = vim.fn.strcharpart
  return dir == "left" and sub(str, idx + 1) or vim.fn.reverse(sub(str, 0, idx))
end

---@param str string
---@param dir 'left' | 'right'
---@param pos integer
---@return Char[]
function M.calc_ranges(str, dir, pos)
  local idx = vim.fn.charidx(str, pos)
  local char_at_pos = vim.fn.nr2char(vim.fn.strgetchar(str, idx))

  local cutted_str = M.prepare_str(str, dir, pos)
  local shifted_pos = pos + #char_at_pos
  local words = vim.split(cutted_str, M.opts.split_by)

  ---@type string[]
  local charlist = {}
  ---@type CharCounter
  local charlist_counter = {}
  ---@type table<number, WordRange>
  local word_ranges = {}

  for i, word in ipairs(words) do
    local word_offset = i == 1 and shifted_pos or word_ranges[i - 1].offset["end"] + 1
    word_ranges[i] = {
      offset = { start = word_offset, ["end"] = word_offset + #word },
      chars = {},
    }

    for j, char in ipairs(vim.fn.split(word, "\\zs")) do
      local char_offset = j == 1 and word_ranges[i].offset.start or word_ranges[i].chars[j - 1].offset["end"]

      word_ranges[i].chars[j] = {
        index = j,
        char = char,
        offset = { start = char_offset, ["end"] = char_offset + #char },
      }
    end

    ---@param chars Char[]
    ---@param counter CharCounter
    ---@return Char
    local function get_least_frequency_char(chars, counter)
      if #chars == 1 then
        chars[1].frequency = counter[chars[1].char] or 0
        return chars[1]
      end
      return vim.iter(chars):skip(1):fold(chars[1], function(acc, char)
        acc.frequency = counter[acc.char] or 0
        char.frequency = counter[char.char] or 0
        return acc.frequency <= char.frequency and acc or char
      end)
    end

    if not vim.tbl_isempty(word_ranges[i].chars) then
      local min = get_least_frequency_char(word_ranges[i].chars, charlist_counter)
      word_ranges[i].rare_char = min
      charlist = vim.list_extend(
        charlist,
        vim
          .iter(word_ranges[i].chars)
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
    .iter(word_ranges)
    :skip(1) -- skip first word because the cursor already on it
    :map(function(m)
      if dir == "right" and m.rare_char then
        local start, end_ = m.rare_char.offset.start, m.rare_char.offset["end"]
        m.rare_char.offset.start = shifted_pos - (end_ - pos)
        m.rare_char.offset["end"] = shifted_pos - (start - pos)
      end
      return m.rare_char
    end)
    :totable()
end

function M.set_hl(ranges, dir)
  local cur = vim.api.nvim_win_get_cursor(0)
  local ns_extmark = vim.api.nvim_create_namespace("__parts.fftt.extmark__")

  if M.opts.hl_groups.dim and M.opts.hl_groups.dim ~= "" then
    local dim_start = dir == "left" and cur[2] or 0
    local dim_end = dir == "left" and #vim.api.nvim_get_current_line() or cur[2]

    vim.api.nvim_buf_set_extmark(0, ns_extmark, cur[1] - 1, dim_start, {
      end_col = dim_end,
      hl_group = M.opts.hl_groups.dim,
    })
  end

  for _, char in pairs(ranges) do
    if not char.frequency then
      goto continue
    end

    local hl_group = M.opts.hl_groups.chars[char.frequency + 1] or M.opts.hl_groups.chars[#M.opts.hl_groups.chars]
    vim.api.nvim_buf_set_extmark(
      0,
      ns_extmark,
      cur[1] - 1,
      char.offset.start,
      { end_col = char.offset["end"], hl_group = hl_group }
    )

    ::continue::
  end
  return ns_extmark
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  local l1 = get_hl(0, { name = "Constant" }).fg
  local l2 = get_hl(0, { name = "String" }).fg
  local l3 = get_hl(0, { name = "WarningMsg" }).fg

  set_hl(0, "FFTTLever1", { underdouble = true, sp = l1 })
  set_hl(0, "FFTTLever2", { underdouble = true, sp = l2 })
  set_hl(0, "FFTTLever3", { underdouble = true, sp = l3 })

  vim.on_key(function(char)
    if M.ns_extmark then
      vim.api.nvim_buf_clear_namespace(0, M.ns_extmark, 0, -1)
      M.ns_extmark = nil
      return -- prevent **any** keypress even fFtT if ns_extmark already exists
    end

    if vim.fn.mode() ~= "n" or vim.fn.state("S") ~= "" then -- works with `n` and `no`
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
    local dir = M.opts.commands[key]
    local ranges = M.calc_ranges(str, dir, pos)
    M.ns_extmark = M.set_hl(ranges, dir)
    vim.cmd.redraw()
  end, ns)
end

return M
