return {
  'folke/zen-mode.nvim',
  cmd = 'ZenMode',
  init = function()
    vim.keymap.set('n', 'Z', '<Cmd>ZenMode<Cr>')
  end,
  config = function()
    require('zen-mode').setup()
  end,
}
