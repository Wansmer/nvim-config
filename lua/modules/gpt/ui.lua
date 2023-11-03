local M = {}

function M.get_layout()
  local width = 80

  local prompt = { border = 'single', height = 10 }
  local shift = prompt.border ~= 'none' and 2 or 0

  local result = { height = (vim.opt.lines:get() - 10) - (prompt.height + shift) }

  result.row = math.floor((vim.opt.lines:get() - result.height - (prompt.height + shift)) / 2)
  prompt.row = result.height + 5

  prompt.width = width - shift

  local common_opts = {
    relative = 'editor',
    border = 'none',
    style = 'minimal',
    width = width,
    col = math.floor((vim.opt.columns:get() - width) / 2),
  }

  local res_buf, res_win = M.open_win(false, vim.tbl_deep_extend('force', common_opts, result))
  local prompt_buf, prompt_win = M.open_win(true, vim.tbl_deep_extend('force', common_opts, prompt))

  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = res_buf })
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = prompt_buf })

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
