return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  enabled = false,
  config = function()
    vim.g.codeium_disable_bindings = 1
    vim.keymap.set('i', '<C-g>', function()
      return vim.fn['codeium#Accept']()
    end, { expr = true })
    vim.keymap.set('i', '<C-j>', function()
      return vim.fn['codeium#Complete']()
    end, { expr = true })
    vim.keymap.set('i', '<C-i>', function()
      return vim.fn['codeium#CycleCompletions'](1)
    end, { expr = true })
    vim.keymap.set('i', '<c-o>', function()
      return vim.fn['codeium#CycleCompletions'](-1)
    end, { expr = true })
    -- TODO: <C-x> conflict with cmp, find best map
    vim.keymap.set('i', '<C-x>', function()
      return vim.fn['codeium#Clear']()
    end, { expr = true })
  end,
}
