local Lens = require('modules.lens.lens')
local state = require('modules.lens.state')

local SymbolUsage = {}

local group = vim.api.nvim_create_augroup('__symbol_usage__', { clear = false })

---@class UserOptions
---@field only_current_line boolean Show usage information on the cursor line only
---@field include_declaration boolean Add number of declaration to count of usage

---Attach buffer to SymbolUsage
---@param bufnr integer
function SymbolUsage.attach(bufnr)
  local state_key = bufnr .. vim.uri_from_bufnr(bufnr)

  state:add_buffer(state_key)

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    Lens.new(bufnr, client, state):run()
  end
end

---Setup SymbolUsage
---@param opts? UserOptions
function SymbolUsage.setup(opts)
  opts = opts or {}
  vim.api.nvim_create_autocmd({ 'LspAttach', 'TextChanged', 'InsertLeave' }, {
    group = group,
    callback = function(event)
      SymbolUsage.attach(event.buf)
    end,
  })
end

return SymbolUsage
