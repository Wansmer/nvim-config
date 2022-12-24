return {
  'danymat/neogen',
  enabled = true,
  -- ft = { 'lua', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  cmd = 'Neogen',
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

    local map = vim.keymap.set
    map('n', '<localleader>a', ':Neogen<CR>')
  end,
}
