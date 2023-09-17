return {
  dir = '~/projects/code/personal/symbol-usage',
  dev = true,
  enabled = true,
  event = 'LspAttach',
  config = function()
    local ok, c = pcall(require, 'serenity.colors')
    local hl = { link = 'Comment' }

    local js_like = function(symbol)
      local refs, defs, impls

      if symbol.references then
        symbol.references = symbol.references - 1
        local usage = symbol.references <= 1 and 'usage' or 'usages'
        local num = symbol.references == 0 and 'no' or symbol.references
        refs = ('%s %s'):format(num, usage)
      end

      if symbol.definition then
        defs = symbol.definition .. ' defs'
      end

      if symbol.implementation then
        impls = symbol.implementation .. ' impls'
      end

      return table.concat({ refs, defs, impls }, ', ')
    end

    if ok then
      hl = { fg = c.cursor_line_number, bold = false, italic = true }
    end
    require('symbol-usage').setup({
      hl = hl,
      filetypes = {
        javascript = { text_format = js_like },
        typescript = { text_format = js_like },
        typescriptreact = { text_format = js_like },
        javascriptreact = { text_format = js_like },
      },
    })
  end,
}
