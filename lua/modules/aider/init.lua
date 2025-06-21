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

  self.job = self.job
    or vim.fn.jobstart({ "aider" }, {
      term = true,
      on_exit = function(_, code)
        if code == 0 then
          vim.api.nvim_win_close(self.win, true)
        end
      end,
    })

  vim.cmd.startinsert()
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
    self.win = nil
    self.buf = nil
    vim.fn.jobstop(self.job)
  end
end

local aider = M.new()

return aider
