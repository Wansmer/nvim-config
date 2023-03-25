return {
  'danymat/neogen',
  enabled = true,
  cmd = 'Neogen',
  keys = { '<localleader>a', 'жф' },
  config = function()
    require('neogen').setup({
      snippet_engine = 'luasnip',
      languages = {
        lua = {
          template = {
            annotation_convention = 'emmylua',
          },
        },
      },
    })
  end,
}
