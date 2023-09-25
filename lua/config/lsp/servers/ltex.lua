-- https://valentjn.github.io/ltex/settings.html

local ft = {
  'gitcommit',
  'markdown',
  'org',
  'pandoc',
  'text',
  'lua',
  'javascript',
  'typescript',
  'typescriptreact',
  'typescript',
  'vue',
  'html',
  'toml',
  'yaml',
  'json',
  'rust',
}

return {
  filetypes = ft,
  settings = {
    ltex = {
      -- It's for checks comments in different languages
      enabled = ft,
      checkFrequency = 'save',
      language = 'en-US',
      diagnosticSeverity = 'information',
      setenceCacheSize = 5000,
      additionalRules = {
        enablePickyRules = true,
      },
    },
  },
}
