local ok, fidget = pcall(require, 'fidget')

if not ok then
  return
end

fidget.setup({
  spinner_rate = 125,
  fidget_decay = 10000,
  task_decay = 1000,
})
