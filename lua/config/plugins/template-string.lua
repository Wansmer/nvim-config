local ft = {
  'typescript',
  'javascript',
  'typescriptreact',
  'javascriptreact',
  'vue',
}

return {
  'axelvc/template-string.nvim',
  enabled = true,
  ft = ft,
  event = 'InsertEnter',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local tstring = require('template-string')
    tstring.setup({
      filetypes = ft,
      jsx_brackets = true,
      remove_template_string = false, -- remove backticks when there are no template string
      restore_quotes = {
        -- quotes used when "remove_template_string" option is enabled
        normal = [[']],
        jsx = [["]],
      },
    })
  end,
}
