-- Original idea: https://github.com/melkster/modicator.nvim

local origin_color = vim.api.nvim_get_hl_by_name('CursorLineNr', true)

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    origin_color = vim.api.nvim_get_hl_by_name('CursorLineNr', true)
  end,
})

local function get_hl(name)
  return vim.api.nvim_get_hl_by_name(name, true)
end

local modes_colors = {
  ['n'] = origin_color,
  ['i'] = get_hl('String'),
  ['v'] = get_hl('Label'),
  ['r'] = get_hl('Error'),
}

vim.api.nvim_create_autocmd('ModeChanged', {
  callback = function()
    local num = vim.api.nvim_get_option_value('number', { buf = 0 })
    if num then
      local override = modes_colors[vim.fn.mode():lower()] or modes_colors.n
      local colors = vim.tbl_deep_extend('force', origin_color, { foreground = override.foreground })
      vim.api.nvim_set_hl(0, 'CursorLineNr', colors)
    end
  end,
})
