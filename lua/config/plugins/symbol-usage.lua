local DEV = false
local SymbolKind = vim.lsp.protocol.SymbolKind

return {
  "Wansmer/symbol-usage.nvim",
  enabled = true,
  dir = DEV and "~/projects/code/personal/symbol-usage.nvim" or nil,
  dev = DEV,
  event = "BufReadPre",
  config = function()
    local hl = { link = "Comment" }

    local ok, c = pcall(require, "serenity.colors")
    if ok then
      hl = { fg = c.cursor_line_number, bold = false, italic = true }
    end

    require("symbol-usage").setup({
      hl = hl,
      vt_position = "end_of_line",
      text_format = function(symbol)
        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          return string.format(" 󰌹 %s %s", num, usage)
        else
          return ""
        end
      end,
      filetypes = {
        svelte = {
          kinds_filter = {
            [SymbolKind.Function] = {
              function(s)
                return not vim.startswith(s.symbol.name, ")}")
              end,
            },
          },
        },
      },
      disable = {
        cond = {
          function()
            local path = vim.fn.expand("%:p")
            return path:find("/node_modules/")
          end,
        },
      },
    })

    vim.keymap.set("n", "<leader>lu", function()
      require("symbol-usage").toggle()
    end)
  end,
}
