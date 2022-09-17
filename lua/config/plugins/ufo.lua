local present, ufo = pcall(require, 'ufo')
if not present then
  return
end

ufo.setup({
  open_fold_hl_timeout = 150,
  close_fold_kinds = { 'comment' },
  enable_get_fold_virt_text = true,
})
