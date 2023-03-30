-- Sets minimum width of current window equals to textwidth
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local ft_ignore = { '', 'nvim-tree', 'neo-tree', 'packer', 'query' }
    local buf = vim.api.nvim_win_get_buf(0)
    local buftype = vim.api.nvim_buf_get_option(buf, 'ft')

    if vim.tbl_contains(ft_ignore, buftype) then
      return
    end

    local width = vim.api.nvim_win_get_width(0)

    if width < PREF.common.textwidth then
      vim.api.nvim_win_set_width(0, PREF.common.textwidth)
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight copied text',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Rid auto comment for new string',
  callback = function()
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})

-- Autoformatting
if PREF.lsp.format_on_save then
  vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
      local client = vim.lsp.get_active_clients({ bufnr = 0 })[1]
      if client then
        vim.lsp.buf.format()
      end
    end,
  })
end

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Jump to the last place you’ve visited in a file before exiting',
  callback = function()
    local ignore_ft = { 'neo-tree', 'toggleterm', 'lazy' }
    local ft = vim.api.nvim_buf_get_option(0, 'filetype')
    if not vim.tbl_contains(ignore_ft, ft) then
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('modules.key_listener')
    require('modules.mode_nr')
    require('modules.thincc')
    require('modules.markdown')
    require('usercmd')
  end,
})

-- Set default colorcolumn
vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Set colorcolumn equals textwidth',
  callback = function(data)
    local tw = vim.api.nvim_buf_get_option(data.buf, 'textwidth')
    vim.api.nvim_win_set_option(0, 'colorcolumn', tostring(tw))
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Open :help with vertical split',
  pattern = { '*.txt' },
  callback = function()
    if vim.bo.filetype == 'help' then
      vim.cmd.wincmd('L')
    end
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local watcher = require('modules.watcher').new()

    watcher:start()
    watcher:on_any({
      function()
        vim.cmd.checktime()
      end,
    })

    local ok, lm = pcall(require, 'langmapper')
    if ok then
      lm.automapping({ buffer = false })
    end
  end,
})
