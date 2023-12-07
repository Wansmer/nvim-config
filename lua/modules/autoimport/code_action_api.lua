
local util = require('vim.lsp.util')
local ms = require('vim.lsp.protocol').Methods

---@param action lsp.Command|lsp.CodeAction
---@param client lsp.Client
---@param ctx lsp.HandlerContext
local function apply_action(action, client, ctx)
  if action.edit then
    util.apply_workspace_edit(action.edit, client.offset_encoding)
  end
  if action.command then
    local command = type(action.command) == 'table' and action.command or action
    client._exec_cmd(command, ctx)
  end
end

---@param choice {action: lsp.Command|lsp.CodeAction, ctx: lsp.HandlerContext}
local function on_user_choice(choice)
  if not choice then
    return
  end
  -- textDocument/codeAction can return either Command[] or CodeAction[]
  --
  -- CodeAction
  --  ...
  --  edit?: WorkspaceEdit    -- <- must be applied before command
  --  command?: Command
  --
  -- Command:
  --  title: string
  --  command: string
  --  arguments?: any[]
  --
  ---@type lsp.Client
  local client = assert(vim.lsp.get_client_by_id(choice.ctx.client_id))
  local action = choice.action
  local bufnr = assert(choice.ctx.bufnr, 'Must have buffer number')

  local reg = client.dynamic_capabilities:get(ms.textDocument_codeAction, { bufnr = bufnr })

  local supports_resolve = vim.tbl_get(reg or {}, 'registerOptions', 'resolveProvider')
    or client.supports_method(ms.codeAction_resolve)

  if not action.edit and client and supports_resolve then
    client.request(ms.codeAction_resolve, action, function(err, resolved_action)
      if err then
        if action.command then
          apply_action(action, client, choice.ctx)
        else
          vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
        end
      else
        apply_action(resolved_action, client, choice.ctx)
      end
    end, bufnr)
  else
    apply_action(action, client, choice.ctx)
  end
end
-- }}

return {
  apply_action = on_user_choice,
}
