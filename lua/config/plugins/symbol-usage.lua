return {
  'Wansmer/symbol-usage.nvim',
  dir = '~/projects/code/personal/symbol-usage.nvim',
  dev = true,
  enabled = true,
  init = function()
    vim.keymap.set('n', '<leader>lu', function()
      require('symbol-usage').toggle()
    end)
  end,
  event = 'LspAttach',
  config = function()
    local ok, c = pcall(require, 'serenity.colors')
    local hl = { link = 'Comment' }

    local js_like = function(symbol)
      local res = {}

      if symbol.references then
        symbol.references = symbol.references - 1
        local usage = symbol.references <= 1 and 'usage' or 'usages'
        local num = symbol.references == 0 and 'no' or symbol.references
        table.insert(res, ('%s %s'):format(num, usage))
      end

      if symbol.definition then
        table.insert(res, symbol.definition .. ' defs')
      end

      if symbol.implementation then
        table.insert(res, symbol.implementation .. ' impls')
      end

      return table.concat(res, ', ')
    end

    if ok then
      hl = { fg = c.cursor_line_number, bold = false, italic = true }
    end

    require('symbol-usage').setup({
      hl = hl,
      vt_position = 'above',
      implementation = { enabled = true },
      filetypes = {
        vue = { text_format = js_like },
        javascript = { text_format = js_like },
        typescript = { text_format = js_like },
        typescriptreact = { text_format = js_like },
        javascriptreact = { text_format = js_like },
      },
    })
  end,
}
