local M = {}

--- Get buffer filepath (name)
---@param bufnr number?
---@return string
function M.get_filepath(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.api.nvim_buf_get_name(bufnr)
end

--- Check if a file exists.
--- @param file string
--- @return boolean
function M.is_file(file)
  return vim.uv.fs_stat(file) ~= nil
end

--- Returns a list of files associated with the all open buffers. If `visible` is true, it will
--- return only files associated with visible buffers.
--- @param visible? boolean
--- @return string[]
function M.list_files(visible)
  local get_bufs = visible and M.list_visible_bufs or vim.api.nvim_list_bufs
  return vim.iter(get_bufs()):map(M.get_filepath):filter(M.is_file):totable()
end

--- Returns a list of visible buffers
--- @return number[]
function M.list_visible_bufs()
  return vim
    .iter(vim.api.nvim_list_wins())
    :map(function(win)
      return vim.api.nvim_win_get_buf(win)
    end)
    :totable()
end

--- Check if buffer is visible
---@param bufnr number
---@return boolean
function M.is_visible(bufnr)
  return vim.list_contains(M.list_visible_bufs(), bufnr)
end

--- Wrap to Bracketed-Paste
--- @param text string|string[]
function M.wrap_to_bracketed_paste(text)
  text = type(text) == "table" and table.concat(text, "\n") or text
  return "\27[200~" .. text .. "\27[201~"
end

return M
