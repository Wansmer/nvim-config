-- https://github.com/jose-elias-alvarez/typescript.nvim
local set_keymap = require('config.lsp.mappings').set_keymap

return {
  disable_commands = false,
  debug = false,
  server = {
    on_attach = function()
      local map = vim.keymap.set
      local bufopts = { noremap = true, silent = true, buffer = 0 }
      map('n', '<leader>lm', ':TypescriptAddMissingImports<CR>', bufopts)
      map('n', '<leader>lo', ':TypescriptOrganizeImports<CR>', bufopts)
      map('n', '<leader>lx', ':TypescriptFixAll<CR>', bufopts)
      map('n', '<leader>lR', ':TypescriptRenameFile<CR>', bufopts)
      set_keymap()
    end,
    autostart = not USER_SETTINGS.lsp.tom_enable,
  },
}
