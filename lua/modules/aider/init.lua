local utils = require("modules.aider.utils")
local g_utils = require("utils")

local group = vim.api.nvim_create_augroup("__parts.aider__", {})

local M = {}
M.__index = M

function M.new()
  return setmetatable({
    win = nil,
    buf = nil,
    job = nil,
    opts = {
      -- Window width configuration:
      -- If win_width is a number less than 1 (e.g., 0.4), it's treated as a ratio of the total Neovim columns.
      -- If win_width is a number 1 or greater (e.g., 80), it's treated as an absolute number of columns.
      win_width = 0.4,
      -- Command-line arguments to pass to the 'aider' executable.
      -- This should be a table of strings, e.g., { "--model", "gpt-4o" }
      cmd_args = { "--no-show-model-warnings" },
      auto_manage_context = {
        -- If true, Aider automatically adds/drops files from its context based on opened/closed buffers.
        enabled = true,
        -- If true, Aider will only add/drop files associated with **visible** buffers.
        visible = true,
      },
    },
    executable = true,
    context = {
      files = {},
    },
  }, M)
end

-- Setup function to configure the Aider instance
function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})

  -- Check if 'aider' executable is available
  if vim.fn.executable("aider") ~= 1 then
    vim.notify(
      "Aider executable not found. Please ensure 'aider' is installed and available in your system's PATH.",
      vim.log.levels.ERROR,
      { title = "Module: Aider" }
    )
    M.executable = false
    return
  end
end

function M:open()
  if not self.executable then
    return
  end

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
    local files = utils.list_files(self.opts.auto_manage_context.visible)
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
      local check_visible = self.opts.auto_manage_context.visible and utils.is_visible(e.buf) or true
      if not self.context.files[utils.get_filepath(e.buf)] and check_visible then
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
        if not self.context.files[utils.get_filepath(e.buf)] then
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
  local sr, sc, er, ec = unpack(g_utils.get_visual_range())
  local text = vim.api.nvim_buf_get_text(0, sr - 1, sc, er - 1, ec, {})

  vim.ui.input({
    prompt = "",
    default = "Explain the code",
  }, function(input)
    self:send_command(utils.wrap_to_bracketed_paste(vim.list_extend({ input }, text)))
  end)
end

local aider = M.new()

return aider
