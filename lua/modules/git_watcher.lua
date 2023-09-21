-- Temporary solution for checks if git is 'dirty'
if vim.fn.has('nvim-0.10') ~= 1 then
  return
end

local function set_interval(callback, interval)
  local timer = vim.loop.new_timer()
  timer:start(0, interval, vim.schedule_wrap(callback))
  return timer
end

local function update_git_status()
  vim.system({ 'git', 'status', '--porcelain' }, { text = true, timeout = 1000 }, function(res)
    if res.signal ~= 0 then
      return
    end
    local prev_dirty = vim.g.__git_dirty
    local new_dirty = vim.trim(res.stdout) ~= ''
    if prev_dirty ~= new_dirty then
      vim.g.__git_dirty = new_dirty
    end
  end)
end

local function update_git_branch()
  vim.system({ 'git', 'branch', '--show-current' }, { text = true, timeout = 1000 }, function(res)
    if res.signal ~= 0 then
      return
    end
    local prev_branch = vim.g.__git_branch
    local new_branch = vim.trim(res.stdout)
    if prev_branch ~= new_branch then
      vim.g.__git_branch = new_branch
    end
  end)
end

local function update_git()
  update_git_status()
  update_git_branch()
end

local interval_timer

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.g.__git_branch = ''
    vim.g.__git_dirty = false
    interval_timer = set_interval(update_git, 3000)
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    if interval_timer then
      interval_timer:stop()
    end
  end,
})
