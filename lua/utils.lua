local M = {}

---Checking if the string in lowercase
---@param str string
---@return boolean
function M.is_lower(str)
  return str == string.lower(str)
end

function M.some(tbl, cb)
  if not vim.tbl_islist(tbl) or vim.tbl_isempty(tbl) then
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
  if not vim.tbl_islist(tbl) or vim.tbl_isempty(tbl) then
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

  return vim.tbl_flatten({ start, end_ })
end

-- From: https://neovim.discourse.group/t/how-do-you-work-with-strings-with-multibyte-characters-in-lua/2437/4
local function char_byte_count(s, i)
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

function M.get_visual_range()
  local sr, sc = unpack(vim.fn.getpos("v"), 2, 3)
  local er, ec = unpack(vim.fn.getpos("."), 2, 3)

  -- To correct work with non-single byte chars
  local byte_c = char_byte_count(M.char_on_pos({ er, ec }))
  ec = ec + (byte_c - 1)

  local range = {}

  if sr == er then
    local cols = sc >= ec and { ec, sc } or { sc, ec }
    range = { sr, cols[1] - 1, er, cols[2] }
  elseif sr > er then
    range = { er, ec - 1, sr, sc }
  else
    range = { sr, sc - 1, er, ec }
  end

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

---Feedkeys witn 'n' (noremap) mode and auto 'replace_termcodes'
---@param f string
function M.feedkeys(f)
  local term = vim.api.nvim_replace_termcodes(f, true, true, true)
  vim.api.nvim_feedkeys(term, "n", true)
end

local function system(cmd)
  local output = vim.fn.system(cmd)
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
    return vim.fn.system("git branch --show-current")
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
  if not ok_image then
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

---Repeat callback by repeat pressing symbol after registred lhs
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

return M
