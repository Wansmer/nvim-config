return {
  'danymat/neogen',
  enabled = true,
  cmd = 'Neogen',
  keys = { '<localleader>a', 'жф' },
  config = function()
    local neogen = require('neogen')
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

    local map = require('utils').map()
    map('n', '<localleader>a', ':Neogen<CR>')
  end,
}
