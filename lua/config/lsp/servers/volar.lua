local tom_fts = {
    'vue',
    'typescript',
    'javascript',
    'javascriptreact',
    'typescriptreact',
    'json',
}

local vue_fts = {
  'vue',
}

local is_take_over_mode = USER_SETTINGS.lsp.tom_enable

local accepted_filetypes = is_take_over_mode and tom_fts or vue_fts

return {
  filetypes = accepted_filetypes,
  init_options = {
    languageFeatures = {
      completion = {
        defaultAttrNameCase = 'kebabCase',
        defaultTagNameCase = 'kebabCase',
      },
    },
  },
}
