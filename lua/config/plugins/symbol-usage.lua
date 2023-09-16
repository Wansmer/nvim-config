return {
  dir = '~/projects/code/personal/symbol-usage',
  dev = true,
  enabled = true,
  event = 'LspAttach',
  config = function()
    local ok, c = pcall(require, 'serenity.colors')
    local hl = { link = 'Comment' }
    if ok then
      hl = { fg = c.cursor_line_number, bold = false, italic = true }
    end
    require('symbol-usage').setup({
      hl = hl,
    })
  end,
}
