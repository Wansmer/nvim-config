local M = {}

M.opts = {
  -- Window width configuration:
  -- If win_width is a number less than 1 (e.g., 0.4), it's treated as a ratio of the total Neovim columns.
  -- If win_width is a number 1 or greater (e.g., 80), it's treated as an absolute number of columns.
  win_width = 0.4,
  -- Command-line arguments to pass to the 'aider' executable.
  -- This should be a table of strings, e.g., { "--model", "gpt-4o" }
  cmd_args = {},
  auto_manage_context = {
    -- If true, Aider automatically adds/drops files from its context based on opened/closed buffers.
    enabled = true,
    -- If true, Aider will only add/drop files associated with **visible** buffers.
    visible = true,
  },
}

function M.merge_opts(opts)
  M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
end

return M
