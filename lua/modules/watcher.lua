local u = require('utils')

local function match(str)
  return function(regex)
    return string.match(str, regex)
  end
end

local function scandir(path, prefix, tree, ignore)
  local dir = vim.fn.readdir(path)
  for _, item in ipairs(dir) do
    local file = path .. '/' .. item
    if not u.some(ignore, match(item)) then
      if vim.fn.isdirectory(file) == 1 then
        scandir(file, item, tree)
      else
        local p = prefix == '' and item or prefix .. '/' .. item
        table.insert(tree, p)
      end
    end
  end
end

local Watcher = {}
Watcher.__index = Watcher

Watcher.new = function(path, opts, ignore)
  path = path or vim.loop.cwd() .. '/'
  opts = opts or { watch_entry = false, stat = false, recursive = true }
  ignore = ignore or { '^%.git', '%~$', '^4913$' }

  local tree = {}
  scandir(path, '', tree, ignore)

  return setmetatable({
    _path = path,
    _opts = opts,
    _tree = tree,
    _ignore = ignore,
    _w = nil,
    _on_add = {},
    _on_delete = {},
    _on_change = {},
    _on_every = {},
  }, Watcher)
end

function Watcher:restart()
  self._w:stop()
  self._w:start(
    self._path,
    self._opts,
    vim.schedule_wrap(function(...)
      self:on_change(...)
    end)
  )
end

function Watcher:remove_file(fname)
  self._tree = vim.tbl_filter(function(name)
    return name ~= fname
  end, self._tree)
end

function Watcher:add_file(fname)
  table.insert(self._tree, fname)
end

function Watcher:on_file_add(cbs)
  if type(cbs) == 'table' then
    vim.list_extend(self._on_add, cbs)
  elseif type(cbs) == 'function' then
    table.insert(self._on_add, cbs)
  end
end

function Watcher:on_file_delete(cbs)
  if type(cbs) == 'table' then
    vim.list_extend(self._on_delete, cbs)
  elseif type(cbs) == 'function' then
    table.insert(self._on_delete, cbs)
  end
end

function Watcher:on_file_change(cbs)
  if type(cbs) == 'table' then
    vim.list_extend(self._on_change, cbs)
  elseif type(cbs) == 'function' then
    table.insert(self._on_change, cbs)
  end
end

function Watcher:on_every_event(cbs)
  if type(cbs) == 'table' then
    vim.list_extend(self._on_every, cbs)
  elseif type(cbs) == 'function' then
    table.insert(self._on_every, cbs)
  end
end

function Watcher:on_change(err, fname, status)
  if err then
    local msg = err .. '. Try to restart watcher for ' .. self._path
    vim.notify(msg, vim.log.levels.WARN, { title = 'Watcher: ' })
    self:restart()
    return
  end

  if not u.some(self._ignore, match(fname)) then
    local fullpath = self._path .. fname

    local is_exist = vim.loop.fs_stat(fullpath)
    local is_watched = vim.tbl_contains(self._tree, fname)
    local is_changed = is_watched and is_exist
    local is_created = not is_watched
    local is_deleted = is_watched and not is_exist

    if is_changed then
      vim.cmd.doautocmd('User WatcherChangedFile')
      for _, cb in ipairs(self._on_change) do
        cb(fname, fullpath)
      end
    elseif is_created then
      self:add_file(fname)
      vim.cmd.doautocmd('User WatcherCreatedFile')
      for _, cb in ipairs(self._on_add) do
        cb(fname, fullpath)
      end
    elseif is_deleted then
      self:remove_file(fname)
      vim.cmd.doautocmd('User WatcherDeletedFile')
      for _, cb in ipairs(self._on_add) do
        cb(fname, fullpath)
      end
    end

    for _, cb in ipairs(self._on_every) do
      cb(fname, fullpath)
    end
  end
end

function Watcher:watch()
  self._w = vim.loop.new_fs_event()

  if not self._w then
    vim.notify(
      'Fail to call "vim.loop.new_fs_event()"',
      vim.log.levels.WARN,
      { title = 'Watcher: ' }
    )
    return
  end

  self._w:start(
    self._path,
    self._opts,
    vim.schedule_wrap(function(...)
      self:on_change(...)
    end)
  )
end

return Watcher
