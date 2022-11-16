local ok, wp = pcall(require, 'window-picker')

if not ok then
  return
end

wp.setup({
  autoselect_one = true,
  include_current = false,
  filter_rules = {
    bo = {
      filetype = {
        'neo-tree',
        'neo-tree-popup',
        'notify',
        'quickfix',
        'toggleterm',
      },
      buftype = { 'terminal', 'toggleterm' },
    },
  },
  other_win_hl_color = '#e35e4f',
})
