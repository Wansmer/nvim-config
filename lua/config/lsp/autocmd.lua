--[[ LSP dependent autocommands ]]

if vim.fn.has('nvim-0.10.0') == 1 then
  vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Enable inlayHint feature',
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.supports_method('textDocument/inlayHint', { bufnr = bufnr }) then
        vim.lsp.inlay_hint.enable(bufnr, PREF.lsp.show_inlay_hints)
      end
    end,
  })
end

-- {{ Toggle diagnostic dependent of insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
  desc = 'Hide diagnostic messages in insert mode',
  callback = function()
    vim.diagnostic.disable()
  end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
  desc = 'Show diagnostic messages in normal mode',
  callback = function()
    vim.diagnostic.enable()
  end,
})

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

local function autoimport()
  local bufnr = vim.api.nvim_get_current_buf()
  local client = vim.lsp.get_clients({ name = 'tsserver' })[1]
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
      return vim.startswith(action.title, 'Add import')
    end, result)

    for _, action in ipairs(filtered_actions) do
      apply_action(action, client, ctx)
    end
  end

  local diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, nil, nil, client.id)
  diagnostics = vim.tbl_filter(function(d)
    return d.code == 2304
  end, diagnostics)

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

-- NO READY!
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*.tsx',
  callback = autoimport,
})
-- }}
