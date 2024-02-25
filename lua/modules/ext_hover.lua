local M = { servers = { "tsserver" } }

local p = vim.lsp.protocol.Methods

function M.extended_hover()
  local start_buf = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients({ bufnr = start_buf })
  ---@type lsp.Client
  local client

  for _, c in ipairs(clients) do
    if
      vim.tbl_contains(M.servers, c.name)
      and c.supports_method(p.textDocument_hover)
      and c.supports_method(p.textDocument_definition)
    then
      client = c
      break
    end
  end

  if not client then
    return
  end

  local handle_result = coroutine.wrap(function(res)
    local lines = vim.tbl_deep_extend("force", res, coroutine.yield())

    vim.schedule(function()
      local content = vim.tbl_flatten({ lines.hover, lines.definition })
      local max = math.max(unpack(vim.iter(content):map(string.len):totable()))

      table.insert(content, #lines.hover + 1, (""):rep(max))
      vim.lsp.util.open_floating_preview(content, "markdown", { focus_id = "hover" })
    end)
  end)

  local params = vim.lsp.util.make_position_params()

  -- HOVER
  client.request(p.textDocument_hover, params, function(err, result, ctx, config)
    if err or not result or vim.tbl_isempty(result) or ctx.bufnr ~= start_buf then
      vim.notify("Problem in hover request in ext_hover", vim.log.levels.INFO)
      handle_result({ hover = {} })
      return
    end

    local content = vim.split(result.contents.value, "\n", { trimempty = true })
    handle_result({ hover = content })
  end, start_buf)

  -- DEFINITION
  client.request(p.textDocument_definition, params, function(err, result, ctx, config)
    if err or not result or vim.tbl_isempty(result) or ctx.bufnr ~= start_buf then
      handle_result({ definition = {} })
      vim.notify("Problem in definition request in ext_hover", vim.log.levels.INFO)
      return
    end

    local def = result[1]

    local path = vim.uri_to_fname(def.targetUri)
    local start_line = def.targetRange.start.line + 1
    local end_line = def.targetRange["end"].line + 1
    local cmd = { "sed", "-n", start_line .. "," .. end_line .. " p", path }
    local on_exit = vim.schedule_wrap(function(res)
      if res.code ~= 0 then
        vim.notify("Problem in `sed` in ext_hover", vim.log.levels.INFO)
        return
      end
      handle_result({
        definition = vim.tbl_flatten({
          "```" .. vim.fn.expand("%:e"),
          vim.split(res.stdout, "\n", { trimempty = true }),
          "```",
        }),
      })
    end)

    vim.system(cmd, { text = true }, on_exit)
  end, start_buf)
end

return M
