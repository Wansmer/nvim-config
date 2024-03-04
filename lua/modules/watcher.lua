-- TODO: to add debounce to avoid twiced events
-- TODO: squash deteded and rename to one event

local u = require("utils")

local function match(str)
  return function(regex)
    return string.match(str, regex) ~= nil
  end
end

---Recursively traverse the directories and collect all entries
---@param path string
---@param store table<string, table>
---@param ignore table
local function collect_entries(path, store, ignore)
  for item, t in vim.fs.dir(path) do
    if not vim.iter(ignore):any(match(item)) then
      local fullpath = vim.fs.joinpath(vim.fn.fnamemodify(path, ":p"), item)
      local stat = vim.uv.fs_stat(fullpath)
      store[fullpath] = {
        ino = stat and stat.ino or nil, -- always not nil
        deleted = false,
      }
      if t == "directory" then
        collect_entries(fullpath, store, ignore)
      end
    end
  end
end

---Check if the file with same inode and marked as deleted is observed in the store
---@param store table<string, table>
---@param stat table
---@return boolean
local function check_prev_version(store, stat)
  if not stat then
    return false
  end

  return vim.iter(store):find(function(_, v)
    return v.ino == stat.ino and v.deleted
  end) ~= nil
end

---Detected fs event
---@param fname string
---@param fullpath string
---@param store table<string, table>
---@return string
local function detect_event(fname, fullpath, store)
  local stat = vim.uv.fs_stat(fullpath)
  local is_exist = stat ~= nil
  local is_watched = store[fullpath] ~= nil
  local event_name = "unknown"

  local is_changed = is_watched and is_exist
  local is_deleted = is_watched and not is_exist
  local is_created = not is_deleted
  local is_renamed = is_created and check_prev_version(store, stat)

  if is_changed then
    event_name = "change"
  elseif is_renamed then
    event_name = "rename"
  elseif is_created then
    event_name = "create"
  elseif is_deleted then
    event_name = "delete"
  end

  return event_name
end

---Check if the path has the root indicator
---@param cwd string
---@param pattern string|table
---@return boolean
local function check_root(cwd, pattern)
  pattern = type(pattern) == "string" and { pattern } or pattern
  pattern = vim.tbl_map(function(el)
    return vim.fs.joinpath(cwd, el)
  end, pattern --[[@as table]])
  return u.some(pattern, vim.uv.fs_stat)
end

local AUTOCMD = {
  ["change"] = "WatcherChangedFile",
  ["create"] = "WatcherCreatedFile",
  ["delete"] = "WatcherDeletedFile",
  ["rename"] = "WatcherRenamedFile",
}

local Watcher = {}
Watcher.__index = Watcher

function Watcher.new(path, opts, ignore, root_pattern)
  if vim.fn.has("nvim-0.10") ~= 1 then
    vim.notify("Only support Neovim 0.10+", vim.log.levels.WARN, { title = "Watcher" })
    return
  end

  path = path or vim.uv.cwd() .. "/"
  opts = opts or { watch_entry = false, stat = false, recursive = true }
  ignore = ignore or { "^%.git", "%.git/", "%~$", "4913$" }
  root_pattern = root_pattern or ".git/"

  local run = true
  local store = {}

  if not check_root(path, root_pattern) then
    run = false
  else
    collect_entries(path, store, ignore)
  end

  return setmetatable({
    _path = path,
    _opts = opts,
    _store = store,
    _ignore = ignore,
    _w = nil,
    _on_create = {},
    _on_delete = {},
    _on_change = {},
    _on_rename = {},
    _on_every = {},
    _run = run,
    _queue = {},
  }, Watcher)
end

function Watcher:_remove_file(fname)
  self._store[fname] = nil
end

function Watcher:_add_file(fname)
  local stat = vim.uv.fs_stat(self._path .. fname)
  if stat then
    self._store[fname] = stat.ino
  end
end

function Watcher:_update_file_store(event, fname)
  if event == "create" then
    self:_add_file(fname)
  elseif event == "delete" then
    self._store[fname].deleted = true
    -- Wait 30ms before deleting file, because it may be part of 'rename' event
    vim.defer_fn(function()
      self:_remove_file(fname)
    end, 30)
  elseif event == "rename" then
    --TODO
  end
end

function Watcher:_on_event(err, fname, status)
  if err then
    local msg = err .. ". Try to restart watcher for " .. self._path
    vim.notify(msg, vim.log.levels.ERROR, { title = "Watcher: " })
  end

  if not u.some(self._ignore, match(fname)) then
    local fullpath = self._path .. fname
    local ino = vim.uv.fs_stat(fullpath) and vim.uv.fs_stat(fullpath).ino or nil

    local event = detect_event(fname, fullpath, self._store)
    local autocmd = AUTOCMD[event]

    if autocmd then
      local cbs = vim.list_extend(self["_on_" .. event], self._on_every)

      vim.api.nvim_exec_autocmds("User", {
        pattern = autocmd,
        data = { file = fullpath, event = event, status = status },
      })

      for _, cb in ipairs(cbs) do
        cb(fname, fullpath, event, status)
      end

      self:_update_file_store(event, fullpath)
    end

    -- self:restart()
  end
end

function Watcher:print_store()
  vim.print(self._store)
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
  self._w = vim.uv.new_fs_event()

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
  return self._store
end

function Watcher:stop()
  self._w:stop()
end

return Watcher
