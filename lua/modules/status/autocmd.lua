local group = vim.api.nvim_create_augroup("__status__", { clear = true })

local function set_hl()
  local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
  local string_hl = vim.api.nvim_get_hl(0, { name = "String" })
  vim.api.nvim_set_hl(0, "TSStatusActive", { bg = statusline_hl.bg, fg = string_hl.fg })
  vim.api.nvim_set_hl(0, "LSPStatusActive", { bg = statusline_hl.bg, fg = string_hl.fg })
  vim.api.nvim_set_hl(0, "FormatterStatusActive", { bg = statusline_hl.bg, fg = string_hl.fg })

  local clnr_hl = vim.api.nvim_get_hl(0, { name = "CursorLineNr" })
  local diag_err_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticError" })
  local diag_hint_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" })
  local diag_info_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" })
  vim.api.nvim_set_hl(0, "NormalStatus", { bg = clnr_hl.fg })
  vim.api.nvim_set_hl(0, "InsertStatus", { bg = diag_info_hl.fg })
  vim.api.nvim_set_hl(0, "VisualStatus", { bg = diag_hint_hl.fg })
  vim.api.nvim_set_hl(0, "ReplaceStatus", { bg = diag_err_hl.fg })
  vim.api.nvim_set_hl(0, "VisualRangeNr", { bg = clnr_hl.bg, fg = clnr_hl.fg, bold = false })

  -- Git indicator
  vim.api.nvim_set_hl(0, "StatusGitClean", { fg = "#00af87", bg = statusline_hl.bg })
  vim.api.nvim_set_hl(0, "StatusGitDirty", { fg = "#870000", bg = statusline_hl.bg })
end

set_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Reload highlights when ColorScheme changed",
  group = group,
  callback = set_hl,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  desc = "Hide statusline and command line in start dashboard",
  pattern = "AlphaReady",
  once = true,
  callback = function(event)
    local prev_status = vim.o.laststatus
    local prev_cmdheight = vim.o.cmdheight
    vim.o.laststatus = 0
    vim.o.cmdheight = 0
    vim.api.nvim_create_autocmd("BufUnload", {
      group = group,
      buffer = event.buf,
      once = true,
      callback = function()
        vim.o.laststatus = prev_status
        vim.o.cmdheight = prev_cmdheight
      end,
    })
  end,
})
