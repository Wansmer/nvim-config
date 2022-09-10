local present, ufo = pcall(require, 'ufo')
if not present then
  return
end

ufo.setup({
  open_fold_hl_timeout = 150,
  close_fold_kinds = { 'comment' },
  enable_fold_end_virt_text = true,
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end,
})
