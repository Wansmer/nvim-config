---@class Watcher
---@field _w uv.uv_fs_event_t
---@field _path string
---@field _ignore string[]
---@field _root string[]
---@field _uv_event_flags fs_event_flags
---@field _store Store
---@field _on_create function[]
---@field _on_delete function[]
---@field _on_change function[]
---@field _on_rename function[]
---@field _on_every function[]
---@field _queue table

---@alias fs_event_flags {watch_entry: boolean, stat: boolean, recursive: boolean}

---@class WatcherOpts
---@field path string Path to watch. Default is cwd
---More info: https://docs.libuv.org/en/v1.x/fs_event.html#c.uv_fs_event_flags
---Default is {watch_entry = false, stat = false, recursive = true}
---@field uv_event_flags {watch_entry: boolean, stat: boolean, recursive: boolean} uv.fs_event flags.
---@field root_patterns string[] Root pattern. Default is [".git/"]
---@field ignore string[] Ignore patterns. Default is ["^%.git", "%.git/", "%~$", "4913$"]

---@alias StoreRecord {ino: number, deleted: boolean, timer?: uv.uv_timer_t}
---@alias Store table<string, StoreRecord>

local AUTOCMD = {
  ["change"] = "WatcherChanged",
  ["create"] = "WatcherCreated",
  ["delete"] = "WatcherDeleted",
  ["rename"] = "WatcherRenamed",
}

local function match(str)
  return function(regex)
    return string.match(str, regex) ~= nil
  end
end

---Recursively traverse the directories and collect all entries
---@param path string
---@param store Store
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
---@param store Store
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
---@param store Store
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
---@param path string
---@param pattern string[]
---@return boolean
local function is_root_found(path, pattern)
  return vim.iter(pattern):any(function(item)
    return vim.uv.fs_stat(vim.fs.joinpath(path, item))
  end)
end

---@class Watcher
local Watcher = {}
Watcher.__index = Watcher

---Create a new Watcher
---@param opts? WatcherOpts
---@return Watcher|nil
function Watcher.new(opts)
  if vim.fn.has("nvim-0.10") ~= 1 then
    vim.notify("Only support Neovim 0.10+", vim.log.levels.WARN, { title = "Watcher" })
    return
  end

  if opts and opts.path then
    opts.path = vim.fn.fnamemodify(opts.path, ":p")
  end

  opts = vim.tbl_deep_extend("force", {
    path = vim.uv.cwd(),
    uv_event_flags = { watch_entry = false, stat = false, recursive = true },
    root_patterns = { ".git/" },
    ignore_patterns = { "^%.git", "%.git/", "%~$", "4913$" },
  }, opts or {})

  if not is_root_found(opts.path, opts.root_patterns) then
    vim.notify("Root pattern is not detected. Directory is not watch now", vim.log.levels.WARN, { title = "Watcher" })
    return
  end

  ---@type Store
  local store = {}

  collect_entries(opts.path, store, opts.ignore_patterns)

  return setmetatable({
    _path = opts.path,
    _uv_event_flags = opts.uv_event_flags,
    _store = store,
    _ignore = opts.ignore_patterns,
    _w = nil,
    _on_create = {},
    _on_delete = {},
    _on_change = {},
    _on_rename = {},
    _on_every = {},
    _queue = {},
  }, Watcher)
end

---Remove record from the Watcher._store
---@param fullpath string
function Watcher:_remove_from_store(fullpath)
  self._store[fullpath] = nil
end

---Add record to the Watcher._store
---@param fullname string
---@param ino number Inode
function Watcher:_add_to_store(fullname, ino)
  self._store[fullname] = { ino = ino, deleted = false }
end

---Handler event: update store, run autocmd, run callbacks
---@param event 'create' | 'delete' | 'change' | 'rename'
---@param autocmd 'WatcherCreated' | 'WatcherDeleted' | 'WatcherChanged' | 'WatcherRenamed'
---@param fullpath string
function Watcher:_handle_event(event, autocmd, fullpath)
  local data = { file = fullpath, event = event, stat = vim.uv.fs_stat(fullpath) }
  local cbs = vim.list_extend(self["_on_" .. event], self._on_every)

  local run_autocmd = function(ovveride)
    vim.api.nvim_exec_autocmds(
      "User",
      vim.tbl_deep_extend("force", {
        pattern = autocmd,
        data = data,
      }, ovveride or {})
    )
  end

  local run_cbs = function()
    for _, cb in ipairs(cbs) do
      cb()
    end
  end

  if event == "create" then
    self:_add_to_store(fullpath, data.stat.ino)
    run_autocmd()
    run_cbs()
  elseif event == "change" then
    run_autocmd()
    run_cbs()
  elseif event == "delete" then
    self._store[fullpath].deleted = true
    -- Wait 30ms before deleting file, because it may be part of 'rename' event
    local delay = 30
    self._store[fullpath].timer = vim.defer_fn(function()
      self:_remove_from_store(fullpath)
      run_autocmd()
      run_cbs()
    end, delay)
  elseif event == "rename" then
    local stat = data.stat
    if not stat then
      return
    end
    local prev_name, prev_record = vim.iter(self._store):find(function(_, v)
      return v.ino == stat.ino and v.deleted
    end)

    if prev_record.timer then
      prev_record.timer:stop()
    end

    self:_remove_from_store(prev_name)
    self:_add_to_store(fullpath, stat.ino)
    run_autocmd()
    run_cbs()
  end
end

function Watcher:_on_event(err, fname, status)
  if err then
    local msg = err .. ". Try to restart watcher for " .. self._path
    vim.notify(msg, vim.log.levels.ERROR, { title = "Watcher" })
  end

  if vim.iter(self._ignore):any(match(fname)) then
    return
  end

  local fullpath = vim.fs.joinpath(self._path, fname)

  local event = detect_event(fname, fullpath, self._store)
  local autocmd = AUTOCMD[event]
  if not autocmd then
    return
  end

  self:_handle_event(event, autocmd, fullpath)
end

---On create event registrator
---@param cbs function|function[]
function Watcher:on_create(cbs)
  if type(cbs) == "table" then
    vim.list_extend(self._on_create, cbs)
  elseif type(cbs) == "function" then
    table.insert(self._on_create, cbs)
  end
end

---On delete event registrator
---@param cbs function|function[]
function Watcher:on_delete(cbs)
  if type(cbs) == "table" then
    vim.list_extend(self._on_delete, cbs)
  elseif type(cbs) == "function" then
    table.insert(self._on_delete, cbs)
  end
end

---On change event registrator
---@param cbs function|function[]
function Watcher:on_change(cbs)
  if type(cbs) == "table" then
    vim.list_extend(self._on_change, cbs)
  elseif type(cbs) == "function" then
    table.insert(self._on_change, cbs)
  end
end

---On every event registrator
---@param cbs function|function[]
function Watcher:on_every(cbs)
  if type(cbs) == "table" then
    vim.list_extend(self._on_every, cbs)
  elseif type(cbs) == "function" then
    table.insert(self._on_every, cbs)
  end
end

---Start the Watcher
function Watcher:start()
  self._w = vim.uv.new_fs_event()

  if not self._w then
    vim.notify('Fail to call "uv.new_fs_event()"', vim.log.levels.WARN, { title = "Watcher: " })
    return
  end

  self._w:start(
    self._path,
    self._uv_event_flags,
    vim.schedule_wrap(function(...)
      self:_on_event(...)
    end)
  )
end

---Restart the Watcher
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

---Stop the Watcher
function Watcher:stop()
  self._w:stop()
end

return Watcher
