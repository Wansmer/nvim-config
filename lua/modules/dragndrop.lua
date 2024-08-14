-- Usage:
--
-- local dnd = DragNDrop.new()
-- dnd:run()
--
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "DragStart",
--   callback = function(event)
--     vim.print("Data DragStart:", event.data)
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "DragEnd",
--   callback = function(event)
--     vim.print("Data DragEnd:", event.data)
--   end,
-- })

local DragNDrop = {}
DragNDrop.__index = DragNDrop

function DragNDrop.new()
  return setmetatable({
    is_drag = false,
    start = {},
    end_ = {},
  }, DragNDrop)
end

function DragNDrop:run()
  local ns = vim.api.nvim_create_namespace("__drag_n_drop__")
  vim.on_key(function(char)
    local key = vim.fn.keytrans(char)
    if key == "<LeftDrag>" and not self.is_drag then
      self:drag_start()
    end

    if key == "<LeftRelease>" and self.is_drag then
      self:drag_end()
    end
  end, ns)
end

function DragNDrop:drag_start()
  self.is_drag = true
  self.start = vim.fn.getmousepos()
  vim.api.nvim_exec_autocmds("User", { pattern = "DragStart", data = { start = self.start } })
end

function DragNDrop:drag_end()
  self.is_drag = false
  vim.api.nvim_exec_autocmds(
    "User",
    { pattern = "DragEnd", data = { start = self.start, end_ = vim.fn.getmousepos() } }
  )
  self.start = {}
  self.end_ = {}
end
