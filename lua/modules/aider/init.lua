local M = {}
M.__index = M

function M.new()
  return setmetatable({
    win = nil,
    buf = nil,
  }, M)
end

function M:open()
  self.win = vim.api.nvim_open_win(0, true, { vertical = true })
  self.buf = self.buf or vim.api.nvim_create_buf(false, false)

  vim.api.nvim_win_set_buf(self.win, self.buf)

  self.job = self.job or vim.fn.jobstart({ "aider" }, {
    term = true,
    on_exit = M.destroy(self),
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
