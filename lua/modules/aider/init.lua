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
      cmd_args = {},
    },
  }, M)
end

-- Setup function to configure the Aider instance
function M:setup(opts)
  self.opts = vim.tbl_deep_extend("force", self.opts, opts or {})
end

function M:open()
  self.buf = self.buf or vim.api.nvim_create_buf(false, false)

  self.win = vim.api.nvim_open_win(self.buf, true, {
    vertical = true,
    width = (self.opts.win_width < 1) and math.floor(vim.o.columns * self.opts.win_width) or self.opts.win_width,
  })

  -- Construct the command by combining "aider" with any specified cmd_args
  local cmd = vim.list_extend({ "aider" }, self.opts.cmd_args)

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

function M:destroy()
  if self.win and vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_close(self.win, true)
    vim.api.nvim_buf_delete(self.buf, { force = true })
    vim.fn.jobstop(self.job)
    self.win = nil
    self.buf = nil
    self.job = nil
  end
end

local aider = M.new()

return aider
