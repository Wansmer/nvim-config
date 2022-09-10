local present, tstring = pcall(require, 'template-string')
if not present then
  return
end

tstring.setup({
  filetypes = {
    'typescript',
    'javascript',
    'typescriptreact',
    'javascriptreact',
    'vue',
  },
  jsx_brackets = true,
  remove_template_string = false, -- remove backticks when there are no template string
  restore_quotes = {
    -- quotes used when "remove_template_string" option is enabled
    normal = [[']],
    jsx = [["]],
  },
})
