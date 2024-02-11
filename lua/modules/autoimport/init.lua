local u = require("utils")
local GROUP = vim.api.nvim_create_augroup("__autoimport__", { clear = true })
local apply_action = require("modules.autoimport.code_action_api").apply_action

local M = {}

M.servers = {
  tsserver = {
    diagnostic_codes = { 2304, 2552 },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    patterns = { "^Add import", "^Update import" },
  },
  ["typescript-tools"] = {
    diagnostic_codes = { 2304, 2552 },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    patterns = { "^Add import", "^Update import" },
  },
  volar = {
    diagnostic_codes = { 2304 },
    ft = { "vue", "javascript", "typescript" },
    patterns = { "^Add import", "^Update import" },
  },
  rust_analyzer = {
    diagnostic_codes = { "E0425" },
    ft = { "rust" },
    patterns = { "^Import" },
  },
}

local function filter_diagnostics(bufnr, client_id, codes)
  return vim.tbl_filter(function(d)
    return vim.tbl_contains(codes, d.code)
  end, vim.lsp.diagnostic.get_line_diagnostics(bufnr, nil, nil, client_id))
end

function M.autoimport(client, bufnr)
  local diagnostics = filter_diagnostics(bufnr, client.id, M.servers[client.name].diagnostic_codes)

  ---@param err? lsp.ResponseError
  ---@param result? (lsp.Command|lsp.CodeAction)[]
  ---@param ctx lsp.HandlerContext
  local function on_result(err, result, ctx)
    if err then
      vim.notify(err.message, vim.log.levels.WARN, { title = "Autoimport" })
      return
    end

    if not result then
      vim.notify("No result", vim.log.levels.WARN, { title = "Autoimport" })
      return
    end

    local filtered_actions = vim.tbl_filter(function(action)
      return u.some(M.servers[client.name].patterns, function(pat)
        -- vim.print(action)
        return action.title:match(pat) ~= nil
      end)
    end, result)

    -- TODO: bad solution. Find better
    table.sort(filtered_actions, function(a, b)
      return #a.title < #b.title
    end)

    -- TODO: remove after testing
    local action = filtered_actions[1]
    apply_action({ action = action, ctx = ctx })
    -- for _, action in ipairs(filtered_actions) do
    --   apply_action({ action = action, ctx = ctx })
    --
    --   local actual_diagnostic = filter_diagnostics(bufnr, client.id, M.servers[client.name].diagnostic_codes)
    --   if #actual_diagnostic == 0 then
    --     break
    --   end
    -- end
  end

  -- Why cycle? Here is not really able to get all code actions in a single request. (Believe me, I tried)
  for _, d in ipairs(diagnostics) do
    local context = {
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Automatic,
      diagnostics = { d },
    }

    local params = {
      textDocument = { uri = vim.uri_from_bufnr(bufnr) },
      range = { start = d.range.start, ["end"] = d.range.start },
      context = context,
    }

    client.request("textDocument/codeAction", params, on_result, bufnr)
  end
end

function M.run()
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = GROUP,
    desc = "Autoimport",
    callback = function(e)
      local clients = vim.lsp.get_clients({ bufnr = e.buf, method = "textDocument/codeAction" })
      local client = vim.iter(clients):find(function(c)
        return M.servers[c.name] ~= nil
      end)
      if client then
        -- vim.defer_fn(function()
        -- end, 0)
        M.autoimport(client, e.buf)
      end
    end,
  })
end

return M
