local M = {}

M.is_list = vim.fn.has("nvim-0.10") == 1 and vim.islist or vim.tbl_islist

function M.to_bool(val)
  return val and true or false
end

---Checking if the string in lowercase
---@param str string
---@return boolean
function M.is_lower(str)
  return str == string.lower(str)
end

function M.some(tbl, cb)
  if not M.is_list(tbl) or vim.tbl_isempty(tbl) then
    return false
  end

  for _, item in ipairs(tbl) do
    if cb(item) then
      return true
    end
  end

  return false
end

function M.every(tbl, cb)
  if not M.is_list(tbl) or vim.tbl_isempty(tbl) then
    return false
  end

  for _, item in ipairs(tbl) do
    if not cb(item) then
      return true
    end
  end

  return true
end

function M.list_contains(list, value)
  return M.some(list, function(v)
    return v == value
  end)
end

function M.char_on_pos(pos)
  pos = pos or vim.fn.getpos(".")
  return tostring(vim.fn.getline(pos[1])):sub(pos[2], pos[2])
end

function M.get_object_range()
  local start = vim.api.nvim_buf_get_mark(0, "[")
  local end_ = vim.api.nvim_buf_get_mark(0, "]")
  end_[2] = end_[2] + 1

  return vim.iter({ start, end_ }):flatten():totable()
end

-- From: https://neovim.discourse.group/t/how-do-you-work-with-strings-with-multibyte-characters-in-lua/2437/4
function M.char_byte_count(s, i)
  if not s or s == "" then
    return 1
  end

  local char = string.byte(s, i or 1)

  -- Get byte count of unicode character (RFC 3629)
  if char > 0 and char <= 127 then
    return 1
  elseif char >= 194 and char <= 223 then
    return 2
  elseif char >= 224 and char <= 239 then
    return 3
  elseif char >= 240 and char <= 244 then
    return 4
  end
end

---@return 'char'|'line'|'block'|nil
function M.visual_mode_type()
  return ({
    ["v"] = "char",
    ["V"] = "line",
    ["^V"] = "block",
  })[vim.fn.strtrans(vim.fn.mode())]
end

function M.get_visual_range()
  local sr, sc = unpack(vim.fn.getpos("v"), 2, 3)
  local er, ec = unpack(vim.fn.getpos("."), 2, 3)

  local mode = M.visual_mode_type()

  if sr > er then
    sr, sc, er, ec = er, ec, sr, sc
  end

  if sr == er or mode == "block" then
    sc, ec = math.min(sc, ec), math.max(sc, ec)
  end

  if mode == "line" then
    sc, ec = 0, -1 -- -1 means last character
  end

  local range = { sr, sc > 0 and sc - 1 or 0, er, ec }

  -- To correct work with non-single byte chars
  local byte_c = M.char_byte_count(M.char_on_pos({ range[3], range[4] }))
  range[4] = range[4] + ((byte_c or 1) - 1)

  return range
end

function M.to_api_range(range)
  local sr, sc, er, ec = unpack(range)
  return sr - 1, sc, er - 1, ec
end

function M.split_padline(line, side)
  side = side or "both"
  local is_left = side == "both" and true or side == "left"
  local is_right = side == "both" and true or side == "right"
  local pad_left, pad_right = "", ""

  if is_left then
    local start, end_ = line:find("^%s+")
    if start then
      pad_left = line:sub(start, end_)
      line = line:sub(end_ + 1)
    end
  end

  if is_right then
    local start, end_ = line:find("%s+$")
    if start then
      pad_right = line:sub(start, end_)
      line = line:sub(1, -(#pad_right + 1))
    end
  end

  return pad_left, line, pad_right
end

function M.pad_start(str, n)
  return string.rep(" ", math.max(n - #str, 0)) .. str
end

function M.pad_end(str, n)
  return str .. string.rep(" ", math.max(n - #str, 0))
end

function M.lazy_rhs_cb(module, cb_name, ...)
  local args = { ... }
  return function()
    if #args == 0 then
      return require(module)[cb_name]()
    else
      return require(module)[cb_name](unpack(args))
    end
  end
end

---Feedkeys with 'n' (noremap) by default
---@param f string
---@param mode? string
function M.feedkeys(f, mode)
  local term = vim.keycode(f)
  vim.api.nvim_feedkeys(term, mode or "n", true)
end

local function system(cmd)
  cmd = type(cmd) == "string" and vim.split(cmd, " ") or cmd
  local output = vim.system(cmd):wait().stdout or ""
  -- To skip no needed terminal messages. Payload is last string.
  local lines = vim.split(vim.trim(output), "\n")
  return lines[#lines]
end

function M.git_status()
  local status = {
    ---@type string Current git branch
    branch = "",
    ---@type string Short name of repo 'User/nameofrepo'
    repo = "",
    ---@type string Remote url of git repo
    remote_url = "",
    ---@type boolean If '.git' exist in current directory
    exist = false,
  }

  local skip = "\\(git@github.com:\\|https:\\/\\/github.com\\/\\|\\.git\\)"

  if vim.loop.fs_stat(vim.loop.cwd() .. "/.git") then
    status.exist = true
    status.branch = system("git branch --show-current")
    status.remote_url = system("git remote get-url --push origin")
    status.repo = vim.fn.substitute(status.remote_url, skip, "", "g")
  end

  return status
end

function M.current_branch()
  if vim.loop.fs_stat(vim.loop.cwd() .. "/.git") then
    return system("git branch --show-current")
  end
  return ""
end

local function lang_for_range(tree, range)
  for name, child in pairs(tree:children()) do
    if name ~= "comment" and child:contains(range) then
      return vim.tbl_isempty(child:children()) and name or lang_for_range(child, range)
    end
  end
  return tree:lang()
end

function M.get_lang()
  local lang = vim.bo.filetype
  local ts_ok, parsers = pcall(require, "nvim-treesitter.parsers")

  if ts_ok then
    local cur = vim.api.nvim_win_get_cursor(0)
    local indent = vim.fn.indent(cur[1])
    if cur[2] < indent then
      cur[2] = cur[2] + indent
    end
    local range = { cur[1] - 1, cur[2], cur[1] - 1, cur[2] }
    local lang_tree = parsers.get_parser()
    lang = lang_for_range(lang_tree, range)
  end

  return lang
end

---Bind arguments to callback
---@param cb function callback to invoke
---@vararg ...any
function M.bind(cb, ...)
  local args = { ... }
  return function()
    if #args == 0 then
      cb()
    else
      cb(unpack(args))
    end
  end
end

---Clear autocmds by group and return callback to restore them
---@param group number|string Group name or id
---@return function Callback to restore cleared group's autocmds
function M.disable_autocmd(group)
  local ok, aus = pcall(vim.api.nvim_get_autocmds, { group = group })
  if ok then
    vim.api.nvim_clear_autocmds({ group = group })
    local function make_opts(au)
      local opts = {
        group = au.group,
        desc = au.desc,
        once = au.once,
        pattern = au.pattern,
      }

      if au.command ~= "" then
        opts.command = au.command
      else
        opts.callback = au.callback
      end

      return opts
    end

    return function()
      vim.defer_fn(function()
        for _, au in ipairs(aus) do
          vim.api.nvim_create_autocmd(au.event, make_opts(au))
        end
      end, 0)
    end
  else
    return function() end
  end
end

---Show image in float window
---@param path string Path to image
---@param win_opts? table Options for float window
---@param image_opts? table Options for image render (see image.nvim ImageGeometry)
function M.show_image(path, win_opts, image_opts)
  local buf = vim.api.nvim_create_buf(false, true)

  local ok, api = pcall(require, "image")
  if not ok then
    return
  end

  local ok_image, image = pcall(api.from_file, path, { buffer = buf })
  if not (ok_image and image) then
    return
  end

  local term = require("image.utils.term")
  local term_size = term.get_size()
  local image_rows = math.floor(image.image_height / term_size.cell_height)
  local image_columns = math.floor(image.image_width / term_size.cell_width)

  win_opts = vim.tbl_deep_extend("force", {
    relative = "cursor",
    col = 0,
    row = 0,
    width = image_columns,
    height = image_rows + 1,
    style = "minimal",
  }, win_opts or {})

  local win = vim.api.nvim_open_win(buf, false, win_opts)

  image.window = win
  -- Needed to correct render if window is moved
  vim.schedule(function()
    image:render(image_opts or {})
  end)

  local group = vim.api.nvim_create_augroup("__image__", { clear = true })
  local cursor = vim.api.nvim_win_get_cursor(0)

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    callback = function()
      local c = vim.api.nvim_win_get_cursor(0)
      if c[1] ~= cursor[1] then
        image:clear()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
        vim.api.nvim_del_augroup_by_name("__image__")
      end
    end,
  })
end

---Concatenate list-like tables
---@vararg table
---@return table
function M.concat(...)
  local res = {}
  local l2 = { ... }
  for _, l in ipairs(l2) do
    for i = 1, #l do
      res[#res + 1] = l[i]
    end
  end
  return res
end

---Repeat callback by repeat pressing symbol after registered lhs
---
---Usage example:
---
---```lua
---vim.keymap.set('n', '<Leader>[', M.repeat_by('[', function() print(123) end))`
---```
---In this case, pressing `<Leader>[[[` will print 123 123 123
---
---@param symbol string
---@param cb function
---@return function
function M.repeat_by(symbol, cb)
  local function repeatable()
    cb() -- Do action on lhs
    local ok, char = pcall(vim.fn.getcharstr)
    if not ok or char == nil then
      return
    end

    -- TODO: add timeout to clear waiting next pressed symbol
    if char == symbol then
      cb() -- Repeat action on pressed symbol
      repeatable()
    else
      -- Send pressed symbol in map mode (map mode is important)
      vim.api.nvim_feedkeys(vim.keycode(char), "m", true)
    end
  end

  return repeatable
end

function M.dot_repeat(dry_run_first, cb, ...)
  local dry_first = dry_run_first
  local args = { ... }
  local name = "__" .. vim.fn.id(cb)

  _G[name] = function()
    for _ = 1, vim.v.count1 do
      if dry_first then
        dry_first = false
      elseif #args == 0 then
        cb()
      else
        cb(unpack(args))
      end
    end
  end

  vim.opt.operatorfunc = "v:lua." .. name
  vim.api.nvim_feedkeys(vim.v.count1 .. "g@l", "nix", true)
end

---Since 0.10 `vim.tbl_add_reverse_lookup` is deprecated
---This func has same behavior as `vim.tbl_add_reverse_lookup`, but not changing original table
---@param o table<string|number, string|number>
---@return table<string|number, string|number>
function M.tbl_add_reverse_lookup(o)
  return vim.iter(o):fold({}, function(t, k, v)
    t[k] = v
    if t[v] then
      error(
        string.format(
          "The reverse lookup found an existing value for %q while processing key %q",
          tostring(v),
          tostring(k)
        )
      )
    end
    t[v] = k
    return t
  end)
end

function M.encodeURL(url)
  local encodedURL = ""
  for i = 1, #url do
    local char = url:sub(i, i)
    if char == " " then
      encodedURL = encodedURL .. "%20"
    else
      encodedURL = encodedURL .. string.format("%%%02X", string.byte(char))
    end
  end
  return encodedURL
end

-- Capitalize first letter
function M.capitalize(str)
  return str:lower():gsub("^%l", string.upper)
end

---Get certain lines from a file
---@param path string
---@param startline integer
---@param endline integer
---@return string[]
function M.get_lines(path, startline, endline)
  local file = io.open(path, "r")
  if not file then
    return {}
  end
  local lines = vim.iter(file:lines()):skip(startline - 1):take(endline - (startline - 1)):totable()
  file:close()
  return lines
end

---Trim indent of each line according to the first line
---@param lines string[]
---@return string[]
function M.trim_indent(lines)
  local indent = lines[1]:match("^(%s*)")
  for i, line in ipairs(lines) do
    if vim.startswith(line, indent) then
      lines[i] = line:sub(#indent + 1)
    end
  end
  return lines
end

local function get_current_layout()
  return vim.trim(vim.system({ "im-select" }, { text = true }):wait().stdout)
end

local RU = "com.apple.keylayout.RussianWin"
local EN = "com.apple.keylayout.ABC"

M.layout = {
  en = function()
    vim.system({ "im-select", EN }):wait()
  end,
  ru = function()
    vim.system({ "im-select", RU }):wait()
  end,
  is_en = function()
    return get_current_layout() == EN
  end,
  is_ru = function()
    return get_current_layout() == RU
  end,
  toggle = function()
    local opposite = { [EN] = RU, [RU] = EN }

    local from = get_current_layout()
    local to = opposite[from]

    vim.system({ "im-select", to }):wait()

    return from, to
  end,
  get = get_current_layout,
}

return M
