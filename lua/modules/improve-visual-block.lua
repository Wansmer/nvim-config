-- Adding visual control for visual-block-mode
-- WARNING: WIP

local M = {}

M.ns = vim.api.nvim_create_namespace("__parts.improve-visual-block__")
M.text_changed_id = nil
M.is_dollar = false
M.is_append = false

M.opts = {
  hls = {
    preview = "Search",
    edited_text = "IncSearch",
  },
}

function M.setup(opts)
  M.opts = not opts and M.opts or vim.tbl_deep_extend("force", M.opts, opts)

  vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "\22:i",
    callback = function()
      local v_start = vim.fn.getpos("'<")
      local v_end = vim.fn.getpos("'>")
      local cursor = vim.api.nvim_win_get_cursor(0)

      local col = cursor[2]

      local line_count = v_end[2] - v_start[2] - 1

      M.text_changed_id = vim.api.nvim_create_autocmd("TextChangedI", {
        nested = true,
        callback = function()
          local ok, _ = pcall(vim.api.nvim_buf_clear_namespace, 0, M.ns, 0, -1)
          if not ok then
            return
          end

          local sr, sc, er, ec = unpack(_G.__last_insert_range)
          local text = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})[1]

          -- hl for place where really editing text
          vim.api.nvim_buf_set_extmark(0, M.ns, sr, sc, {
            end_col = ec,
            hl_group = M.opts.hls.edited_text,
          })

          -- hl and extmarks for preview
          for i = 0, line_count do
            local cur_line = i + v_start[2] + 1
            local line = vim.api.nvim_buf_get_lines(0, cur_line - 1, cur_line, false)[1]

            local spaces = ""
            local is_need_set_extmark = true

            if not M.is_append then
              is_need_set_extmark = col == 0 or not (line == "" or #line < col)
            end

            if is_need_set_extmark then
              if not M.is_dollar and #line < col then
                spaces = (" "):rep(col - #line)
              end

              if M.is_dollar then
                col = #line
              end

              vim.api.nvim_buf_set_extmark(0, M.ns, cur_line - 1, col, {
                virt_text = { { spaces, "NonText" }, { text, M.opts.hls.preview } },
                virt_text_pos = "inline",
                strict = false,
                -- TODO: find right priority to avoid conflict with indent-blankline
              })
            end
          end
        end,
      })
    end,
  })

  vim.on_key(function(key)
    if vim.api.nvim_get_mode().mode ~= "\22" then
      return
    end

    if key == "$" then
      M.is_dollar = true
      return
    end

    if key ~= "A" and M.is_dollar then
      M.is_dollar = false
      return
    end

    M.is_append = key == "A"
  end, M.ns)

  -- Clear after insert stop
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      -- TODO: Check, if already cleared
      pcall(vim.api.nvim_del_autocmd, M.text_changed_id)
      pcall(vim.api.nvim_buf_clear_namespace, 0, M.ns, 0, -1)
      M.is_dollar = false
      M.is_append = false
    end,
  })
end

return M
