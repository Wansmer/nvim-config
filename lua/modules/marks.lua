--[[ Small plugin to add visual control for marks in the current buffer ]]

local ns = vim.api.nvim_create_namespace("__parks.marks__")
local M = {}

M.ns_extmark = nil

M.opts = {
  dim_mark_lines = true,
  signcolumn = false,
  labels = true,
  hl = {
    dim = "Comment",
    col = "Constant",
    mark = "IncSearch",
  },
}

function M.setup(opts)
  opts = vim.tbl_deep_extend("force", opts or {}, M.opts)

  vim.on_key(function(key, typed)
    if M.ns_extmark then
      vim.api.nvim_buf_clear_namespace(0, M.ns_extmark, 0, -1)
      M.ns_extmark = nil
      return
    end

    local is_pending = vim.fn.state("o") ~= ""
    if vim.fn.mode() ~= "n" or is_pending then
      return
    end

    if not vim.list_contains({ "'", "`" }, key) then
      return
    end

    M.ns_extmark = vim.api.nvim_create_namespace("__parts.marks.extmark__")
    local marks = vim.fn.getmarklist("%")

    for _, mark in ipairs(marks) do
      local linenr = mark.pos[2] - 1
      local col = mark.pos[3]

      if M.opts.signcolumn then
        vim.api.nvim_buf_set_extmark(0, M.ns_extmark, linenr, 0, {
          sign_text = (mark.mark):sub(2, 2),
          priority = 99,
          sign_hl_group = opts.hl.col,
        })
      end

      if M.opts.dim_mark_lines then
        local dim_start = 0
        local dim_end = #(vim.api.nvim_buf_get_lines(0, 0, -1, false)[linenr + 1] or "")
        vim.api.nvim_buf_set_extmark(0, M.ns_extmark, linenr, dim_start, {
          end_col = dim_end,
          hl_group = M.opts.hl.dim,
          strict = false,
        })
      end

      if opts.labels then
        vim.api.nvim_buf_set_extmark(0, M.ns_extmark, linenr, col - 1 < 0 and 0 or col - 1, {
          virt_text = { { mark.mark:sub(2, 2), opts.hl.mark } },
          virt_text_pos = "overlay",
          strict = false,
        })
      end

      vim.cmd.redraw()
    end
  end, ns)
end

return M
