-- Based on vim.lsp.buf.code_action

local u = require('utils')
local GROUP = vim.api.nvim_create_augroup('__autoimport__', { clear = true })

---@param action lsp.Command|lsp.CodeAction
---@param client lsp.Client
---@param ctx lsp.HandlerContext
local function apply_action(action, client, ctx)
  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  end
  if action.command then
    local command = type(action.command) == 'table' and action.command or action
    client._exec_cmd(command, ctx)
  end
end

local M = {}

M.servers = {
  tsserver = {
    diagnostic_codes = { 2304 },
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    patterns = { '^Add import', '^Update import' },
  },
  volar = {
    diagnostic_codes = { 2304 },
    ft = { 'vue', 'javascript', 'typescript' },
    patterns = { '^Add import', '^Update import' },
  },
}

function M.autoimport(server)
  local bufnr = vim.api.nvim_get_current_buf()
  local client = vim.lsp.get_clients({ name = server, bufnr = bufnr })[1]
  if not client then
    return
  end

  ---@param err? lsp.ResponseError
  ---@param result? (lsp.Command|lsp.CodeAction)[]
  ---@param ctx lsp.HandlerContext
  local function on_result(err, result, ctx)
    if err then
      vim.notify(err.message, vim.log.levels.WARN, { title = 'on_code_action' })
      return
    end

    if not result then
      vim.notify('No result', vim.log.levels.WARN, { title = 'on_code_action' })
      return
    end

    local filtered_actions = vim.tbl_filter(function(action)
      return u.some(M.servers[server].patterns, function(pat)
        return action.title:match(pat) ~= nil
      end)
    end, result)

    for _, action in ipairs(filtered_actions) do
      apply_action(action, client, ctx)
    end
  end

  local diagnostics = vim.tbl_filter(function(d)
    return vim.tbl_contains(M.servers[server].diagnostic_codes, d.code)
  end, vim.lsp.diagnostic.get_line_diagnostics(bufnr, nil, nil, client.id))

  -- Why cycle? Here is not really able to get all code actions in a single request. (Believe me, I tried)
  for _, d in ipairs(diagnostics) do
    local context = {
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Automatic,
      diagnostics = { d },
    }

    local params = {
      textDocument = { uri = vim.uri_from_bufnr(bufnr) },
      range = { start = d.range.start, ['end'] = d.range.start },
      context = context,
    }

    client.request('textDocument/codeAction', params, on_result, bufnr)
  end
end

function M.run()
  for server, preset in pairs(M.servers) do
    vim.api.nvim_create_autocmd('InsertLeave', {
      desc = 'Autoimport for ' .. server,
      group = GROUP,
      callback = function(e)
        if vim.tbl_contains(preset.ft, vim.bo[e.buf].ft) then
          M.autoimport(server)
        end
      end,
    })
  end
end

return M
