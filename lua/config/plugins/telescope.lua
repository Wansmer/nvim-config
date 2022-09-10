local present, telescope = pcall(require, 'telescope')
if not present then
  return
end

telescope.setup({
  defaults = {
    prompt_prefix = ' ',
    selection_caret = ' ',
    path_display = { 'smart' },
    layout_strategy = 'horizontal',
    layout_config = {
      prompt_position = 'top',
    },
    file_ignore_patterns = {
      '.git/',
      'node_modules/*',
    },
  },
})
