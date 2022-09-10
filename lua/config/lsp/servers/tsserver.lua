-- https://github.com/jose-elias-alvarez/typescript.nvim
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
    end,
  },
}
