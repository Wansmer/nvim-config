local M = {}

--- Get buffer filepath (name)
---@param bufnr number
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

--- Returns a list of files associated with the all open buffers.
--- @return string[]
function M.list_files()
  return vim.iter(vim.api.nvim_list_bufs()):map(M.get_filepath):filter(M.is_file):totable()
end

return M
