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

local is_take_over_mode = PREF.lsp.tom_enable

local accepted_filetypes = is_take_over_mode and tom_fts or vue_fts

return {
  filetypes = accepted_filetypes,
  single_file_support = true,
  init_options = {
    typescript = {
      tsdk = '/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib/tsserverlibrary.js',
    },
    languageFeatures = {
      completion = {
        defaultAttrNameCase = 'kebabCase',
        defaultTagNameCase = 'kebabCase',
      },
    },
  },
}
