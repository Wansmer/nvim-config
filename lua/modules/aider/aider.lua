local u = require("modules.aider.utils")
local gu = require("utils")

local group = vim.api.nvim_create_augroup("__parts.aider__", {})

local M = {}
M.__index = M

function M.new(opts)
  return setmetatable({
    win = nil,
    buf = nil,
    job = nil,
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

  local cmd = { "aider" }

  -- Construct the command by combining "aider" with any specified cmd_args
  cmd = vim.list_extend(cmd, self.opts.cmd_args)

  -- It should be run only once
  if not self.job and self.opts.auto_manage_context.enabled then
    local files = u.list_files(self.opts.auto_manage_context.visible)
    self.context.files = vim.iter(files):fold({}, function(acc, file)
      acc[file] = true
      return acc
    end)
    cmd = vim.list_extend(cmd, files)
    self:set_autocmds()
  end

  self.job = self.job
    or vim.fn.jobstart(cmd, {
      term = true,
      on_exit = function()
        self:destroy()
      end,
    })

  vim.schedule(function()
    vim.cmd.startinsert()
  end)
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

--- This function checks if the buffer is associated with an actual file on disk and, if  so, adds
--- that file to the Aider instance.
--- @param bufnr? number Optional buffer number. Defaults to the current buffer.
function M:add_file(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  if vim.uv.fs_stat(filepath) then
    self:send_command("/add " .. filepath)
    self.context.files[filepath] = true
  end
end

--- Drops a file from the Aider instance.
--- @param filepath string The full path to the file to drop.
function M:drop_file(filepath)
  if not filepath or filepath == "" then
    return
  end
  self:send_command("/drop " .. filepath)
  self.context.files[filepath] = nil
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

function M:set_autocmds()
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

local aider = M.new()

return aider
