local ok, neogen = pcall(require, 'neogen')

if not ok then
  return
end

neogen.setup({
  snippet_engine = 'luasnip',
  languages = {
    lua = {
      template = {
        annotation_convention = 'emmylua',
      },
    },
  },
})
