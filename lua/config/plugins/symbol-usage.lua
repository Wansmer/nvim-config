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
  event = 'BufReadPre',
  config = function()
    local js = {
      text_format = function(symbol)
        local res = {}

        if symbol.references then
          symbol.references = symbol.references > 0 and symbol.references - 1 or symbol.references
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
      end,
    }

    local hl = { link = 'Comment' }

    local ok, c = pcall(require, 'serenity.colors')
    if ok then
      hl = { fg = c.cursor_line_number, bold = false, italic = true }
    end

    local function h(name)
      return vim.api.nvim_get_hl(0, { name = name })
    end

    -- hl-groups can have any name
    vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
    vim.api.nvim_set_hl(0, 'SymbolUsageContent', { bg = h('CursorLine').bg, fg = h('Comment').fg, italic = true })
    vim.api.nvim_set_hl(0, 'SymbolUsageRef', { fg = h('Function').fg, bg = h('CursorLine').bg, italic = true })
    vim.api.nvim_set_hl(0, 'SymbolUsageDef', { fg = h('Type').fg, bg = h('CursorLine').bg, italic = true })
    vim.api.nvim_set_hl(0, 'SymbolUsageImpl', { fg = h('@keyword').fg, bg = h('CursorLine').bg, italic = true })

    local function text_format(symbol)
      local res = {}

      local round_start = { '', 'SymbolUsageRounding' }
      local round_end = { '', 'SymbolUsageRounding' }

      if symbol.references then
        -- symbol.references = symbol.references > 0 and symbol.references - 1 or symbol.references
        local usage = symbol.references <= 1 and 'usage' or 'usages'
        local num = symbol.references == 0 and 'no' or symbol.references
        table.insert(res, round_start)
        table.insert(res, { '󰌹 ', 'SymbolUsageRef' })
        table.insert(res, { ('%s %s'):format(num, usage), 'SymbolUsageContent' })
        table.insert(res, round_end)
      end

      if symbol.definition then
        if #res > 0 then
          table.insert(res, { ' ', 'NonText' })
        end
        table.insert(res, round_start)
        table.insert(res, { '󰳽 ', 'SymbolUsageDef' })
        table.insert(res, { symbol.definition .. ' defs', 'SymbolUsageContent' })
        table.insert(res, round_end)
      end

      if symbol.implementation then
        if #res > 0 then
          table.insert(res, { ' ', 'NonText' })
        end
        table.insert(res, round_start)
        table.insert(res, { '󰡱 ', 'SymbolUsageImpl' })
        table.insert(res, { symbol.implementation .. ' impls', 'SymbolUsageContent' })
        table.insert(res, round_end)
      end

      return res
    end

    require('symbol-usage').setup({
      hl = hl,
      vt_position = 'above',
      request_pending_text = {
        { '', 'SymbolUsageRounding' },
        { ' loading...', 'SymbolUsageContent' },
        { '', 'SymbolUsageRounding' },
      },
      references = { enabled = true, include_declaration = false },
      definition = { enabled = false },
      implementation = { enabled = false },
      text_format = text_format,
      filetypes = { vue = js },
    })
  end,
}
