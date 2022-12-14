local ok, mnl = pcall(require, 'mason-null-ls')

if not ok then
  return
end

mnl.setup({
  automatic_installation = true,
})
