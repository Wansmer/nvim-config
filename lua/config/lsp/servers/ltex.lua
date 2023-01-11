return {
  cmd = { 'ltex-ls' },
  filetypes = { 'markdown', 'text' },
  flags = { debounce_text_changes = 300 },
  settings = {
    ltex = {
      language = 'auto',
      -- language = 'ru-RU',
    },
  },
}
