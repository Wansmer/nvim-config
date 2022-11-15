local ok, aerial = pcall(require, 'aerial')

if not ok then
  return
end

aerial.setup({
  on_attach = function(bufnr)
    vim.keymap.set('n', '<leader>ol', ':AerialToggle<CR>', { buffer = bufnr })
  end,
  layout = {
    width = '30',
  },
})
