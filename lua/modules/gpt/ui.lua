local M = {}

function M.get_layout()
  local width = 100

  local prompt = {
    border = "single",
    height = 10,
    title = " Ask anything (md syntax): ",
    zindex = 51, -- should be above result window
  }

  local prompt_shift = prompt.border ~= "none" and 2 or 0

  local result = {
    height = (vim.opt.lines:get() - 10) - (prompt.height + prompt_shift),
    title = " Chat GPT: ",
    border = "none",
    zindex = 50,
  }

  local result_shift = result.border ~= "none" and 2 or 0
  result.height = result.height + result_shift

  result.row = math.floor((vim.opt.lines:get() - result.height - (prompt.height + prompt_shift)) / 2)
  prompt.row = result.height + 5

  prompt.width = width - prompt_shift
  result.width = width - result_shift

  local common_opts = {
    relative = "editor",
    border = "none",
    style = "minimal",
    width = width,
    col = math.floor((vim.opt.columns:get() - width) / 2),
  }

  local res_buf, res_win = M.open_win(false, vim.tbl_deep_extend("force", common_opts, result))
  local prompt_buf, prompt_win = M.open_win(true, vim.tbl_deep_extend("force", common_opts, prompt))

  vim.api.nvim_set_option_value("filetype", "markdown", { buf = res_buf })
  vim.api.nvim_set_option_value("filetype", "markdown", { buf = prompt_buf })

  vim.wo[res_win].wrap = true
  vim.wo[prompt_win].wrap = true

  vim.wo[res_win].statuscolumn = " "
  vim.wo[prompt_win].statuscolumn = " "

  vim.wo[res_win].winhl =
    "Normal:TelescopeResultsNormal,LineNr:TelescopeResultsNormal,WinBar:TelescopeResultsNormal,WinBarNC:TelescopeResultsNormal"
  vim.wo[prompt_win].winhl =
    "Normal:TelescopePromptNormal,LineNr:TelescopePromptNormal,WinBar:TelescopePromptNormal,WinBarNC:TelescopePromptNormal"

  vim.wo[prompt_win].winbar = " "
  vim.wo[res_win].scrolloff = 5

  return {
    prompt = { buf = prompt_buf, win = prompt_win },
    result = { buf = res_buf, win = res_win },
  }
end

function M.open_win(enter, opts)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, enter, opts)
  return buf, win
end

return M
