local u = require("utils")

local uv = vim.fn.has("nvim-0.10") == 1 and vim.uv or vim.loop

local function match(str)
  return function(regex)
    return string.match(str, regex)
  end
end

local function iter_dir(path)
  local fs = uv.fs_scandir(path)
  return function()
    if not fs then
      return
    end
    return uv.fs_scandir_next(fs)
  end
end

local function scandir(path, prefix, tree, ignore)
  for item, t in iter_dir(path) do
    local file = path .. "/" .. item
    if not u.some(ignore, match(item)) then
      if t == "directory" then
        scandir(file, item, tree)
      else
        local p = prefix == "" and item or prefix .. "/" .. item
        table.insert(tree, p)
      end
    end
  end
end

local function detect_event(fname, fullpath, tree)
  local is_exist = uv.fs_stat(fullpath)
  local is_watched = vim.tbl_contains(tree, fname)

  local event_name = "unknown"
  local is_changed = is_watched and is_exist
  local is_deleted = is_watched and not is_exist
  local is_created = not is_watched

  if is_changed then
    event_name = "change"
  elseif is_created then
    event_name = "create"
  elseif is_deleted then
    event_name = "delete"
  end

  return event_name
end

local function check_root(cwd, pattern)
  pattern = type(pattern) == "string" and { pattern } or pattern
  pattern = vim.tbl_map(function(el)
    return cwd .. el
  end, pattern)
  return u.some(pattern, uv.fs_stat)
end

local AUTOCMD = {
  ["change"] = "User WatcherChangedFile",
  ["create"] = "User WatcherCreatedFile",
  ["delete"] = "User WatcherDeletedFile",
  ["rename"] = "User WatcherRenamedFile", -- no implement. TODO: find how to detect renaming
}

local Watcher = {}
Watcher.__index = Watcher

Watcher.new = function(path, opts, ignore, root_pattern)
  path = path or uv.cwd() .. "/"
  opts = opts or { watch_entry = false, stat = false, recursive = true }
  ignore = ignore or { "^%.git", "%.git/", "%~$", "4913$" }
  root_pattern = root_pattern or ".git/"
  local run = true
  local tree = {}

  if not check_root(path, root_pattern) then
    run = false
  else
    scandir(path, "", tree, ignore)
  end

  return setmetatable({
    _path = path,
    _opts = opts,
    _tree = tree,
    _ignore = ignore,
    _w = nil,
    _on_create = {},
    _on_delete = {},
    _on_change = {},
    _on_every = {},
    _run = run,
  }, Watcher)
end

function Watcher:_remove_file(fname)
  self._tree = vim.tbl_filter(function(name)
    return name ~= fname
  end, self._tree)
end

function Watcher:_add_file(fname)
  table.insert(self._tree, fname)
end

function Watcher:_update_file_tree(event, fname)
  if event == "create" then
    self:_add_file(fname)
  elseif event == "delete" then
    self:_remove_file(fname)
  end
end

function Watcher:_on_event(err, fname, status)
  if err then
    local msg = err .. ". Try to restart watcher for " .. self._path
    vim.notify(msg, vim.log.levels.ERROR, { title = "Watcher: " })
  end

  if not u.some(self._ignore, match(fname)) then
    local fullpath = self._path .. fname

    local event = detect_event(fname, fullpath, self._tree)
    local autocmd = AUTOCMD[event]

    if autocmd then
      local cbs = vim.list_extend(self["_on_" .. event], self._on_every)

      vim.cmd.doautocmd(autocmd)
      print("Len cbs: " .. #cbs)

      for _, cb in ipairs(cbs) do
        cb(fname, fullpath, event, status)
      end

      self:_update_file_tree(event, fname)
    end

    self:restart()
  end
end

function Watcher:print_tree()
  vim.print(self._tree)
end

function Watcher:on_create(cbs)
  if type(cbs) == "table" then
    vim.list_extend(self._on_create, cbs)
  elseif type(cbs) == "function" then
    table.insert(self._on_create, cbs)
  end
end

function Watcher:on_delete(cbs)
  if type(cbs) == "table" then
    vim.list_extend(self._on_delete, cbs)
  elseif type(cbs) == "function" then
    table.insert(self._on_delete, cbs)
  end
end

function Watcher:on_change(cbs)
  if type(cbs) == "table" then
    vim.list_extend(self._on_change, cbs)
  elseif type(cbs) == "function" then
    table.insert(self._on_change, cbs)
  end
end

function Watcher:on_any(cbs)
  if type(cbs) == "table" then
    vim.list_extend(self._on_every, cbs)
  elseif type(cbs) == "function" then
    table.insert(self._on_every, cbs)
  end
end

function Watcher:start()
  self._w = uv.new_fs_event()

  if not self._w then
    vim.notify('Fail to call "uv.new_fs_event()"', vim.log.levels.WARN, { title = "Watcher: " })
    return
  end

  if not self._run then
    vim.notify("Root pattern is not detected. Directory is not watch now", vim.log.levels.WARN, { title = "Watcher: " })
    self._w:stop()
    return
  end

  self._w:start(
    self._path,
    self._opts,
    vim.schedule_wrap(function(...)
      self:_on_event(...)
    end)
  )
end

function Watcher:restart()
  self._w:stop()
  self._w:start(
    self._path,
    self._opts,
    vim.schedule_wrap(function(...)
      self:_on_event(...)
    end)
  )
end

function Watcher:get_files()
  return self._tree
end

function Watcher:stop()
  self._w:stop()
end

return Watcher
