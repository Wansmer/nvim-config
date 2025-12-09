local u = require("modules.aider.utils")
local gu = require("utils")

local group = vim.api.nvim_create_augroup("__parts.aider__", {})

local M = {}
M.__index = M

local aider_proxy = setmetatable({}, {
  __index = function()
    vim.notify(
      "Aider is not initialized. Ensure you have `aider` executable and `setup()` function is called.",
      vim.log.levels.ERROR,
      { title = "Aider" }
    )
    return function() end
  end,
})

function M.new()
  if vim.fn.executable("aider") ~= 1 then
    vim.notify(
      "Aider is not executable. Ensure you have `aider` in your PATH.",
      vim.log.levels.ERROR,
      { title = "Aider" }
    )
    return aider_proxy
  end

  return setmetatable({
    win = nil,
    buf = nil,
    job = nil,
    read_output = false,
    opts = require("modules.aider.opts").opts,
    context = {
      files = {},
    },
  }, M)
end

function M:open()
  self.buf = self.buf or vim.api.nvim_create_buf(false, false)

  self.win = vim.api.nvim_open_win(self.buf, true, {
    vertical = true,
    width = (self.opts.win_width < 1) and math.floor(vim.o.columns * self.opts.win_width) or self.opts.win_width,
  })

  local ok, err = self:_ensure_job_running()
  if not ok then
    vim.notify(err, vim.log.levels.ERROR, { title = "Aider" })
    return
  end

  vim.schedule(function()
    vim.cmd.startinsert()
  end)
end

---Check if Aider's job is running, otherwise start new job. Return job status and error message
---@return boolean, string
function M:_ensure_job_running()
  if self.job then
    return true, ""
  end

  if self.opts.auto_manage_context.enabled then
    self:_populate_files()
  end

  -- Construct the command by combining "aider" with any specified cmd_args and opened/visible files
  local cmd = vim.iter({ "aider", self.opts.cmd_args, vim.tbl_keys(self.context.files) }):flatten():totable()
  local job = vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify("Aider exited with code " .. exit_code, vim.log.levels.ERROR, { title = "Aider" })
        return
      end
      self:destroy()
    end,
    on_stdout = function(_, data)
      -- if self.read_output then
      -- vim.print(data)
      -- self.read_output = false
      -- end
    end,
    stdout_buffered = true,
  })

  if job <= 0 then
    self = aider_proxy
    return false, job == 0 and "Invalid `jobstart` arguments" or "Shell or Aider is not executable"
  end

  self.job = job

  if self.opts.auto_manage_context.enabled then
    self:_set_autocmds()
  end

  return true, ""
end

-- Toggle the Aider window
function M:toggle()
  if self.win and vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_close(self.win, true)
  else
    self:open()
  end
end

--- Sends a command string to the running Aider terminal job.
--- @param command string The command string to send.
function M:send_command(command)
  if self.job and vim.fn.jobpid(self.job) ~= -1 then
    vim.api.nvim_chan_send(self.job, command .. "\n")
  else
    vim.notify("Aider job is not running. Cannot send command.", vim.log.levels.WARN, { title = "Module: Aider" })
  end
end

---This function checks if the buffer/file is associated with an actual file on disk and, if so,
---adds that file to the Aider instance.
---@param target? number|string Optional buffer number or filepath. Defaults to current buffer.
---@param readonly? boolean Whether the file should be opened in read-only mode. Defaults to false.
function M:add_file(target, readonly)
  local filepath = type(target) == "string" and target or u.get_filepath(target--[[@as number?]])

  if filepath and u.is_file(filepath) then
    local cmd = readonly and "/read-only" or "/add"
    self:send_command(("%s %s"):format(cmd, filepath))
    self.context.files[filepath] = true
  end
end

--- Drops a file from the Aider instance.
--- @param target? number|string Optional buffer number or filepath to drop.
function M:drop_file(target)
  local filepath = type(target) == "string" and target or u.get_filepath(target--[[@as number?]])

  if filepath and self.context.files[filepath] then
    self:send_command("/drop " .. filepath)
    self.context.files[filepath] = nil
  end
end

function M:destroy()
  pcall(vim.api.nvim_win_close, self.win, true)
  pcall(vim.api.nvim_buf_delete, self.buf, { force = true })
  pcall(vim.api.nvim_del_augroup_by_name, group)
  vim.fn.jobstop(self.job)
  self.win = nil
  self.buf = nil
  self.job = nil
end

function M:_populate_files()
  local files = u.list_files(self.opts.auto_manage_context.visible)
  self.context.files = vim.iter(files):fold({}, function(acc, file)
    acc[file] = true
    return acc
  end)
end

function M:_set_autocmds()
  vim.api.nvim_create_autocmd("BufAdd", {
    pattern = { "*" },
    group = group,
    callback = function(e)
      local check_visible = self.opts.auto_manage_context.visible and u.is_visible(e.buf) or true
      if not self.context.files[u.get_filepath(e.buf)] and check_visible then
        self:add_file(e.buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufDelete", {
    pattern = { "*" },
    group = group,
    callback = function(e)
      self:drop_file(e.file)
    end,
  })

  if self.opts.auto_manage_context.visible then
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = { "*" },
      group = group,
      callback = function(e)
        if not self.context.files[u.get_filepath(e.buf)] then
          self:add_file(e.buf)
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufWinLeave", {
      pattern = { "*" },
      group = group,
      callback = function(e)
        self:drop_file(e.file)
      end,
    })
  end
end

function M:clear()
  self:send_command("/clear")
  self.context.files = {}
end

function M:send_selected()
  if vim.fn.mode():lower() ~= "v" then
    return
  end
  local sr, sc, er, ec = unpack(gu.get_visual_range())
  local text = vim.api.nvim_buf_get_text(0, sr - 1, sc, er - 1, ec, {})

  vim.ui.input({
    prompt = "",
    default = "Explain the code",
  }, function(input)
    self:send_command(u.wrap_to_bracketed_paste(vim.list_extend({ input }, text)))
  end)
end

function M:commit(dry)
  if dry then
    self.read_output = true
    self:send_command(commit_prompt)
  else
    self:send_command("/commit")
  end
end

local aider = M.new()

return aider
