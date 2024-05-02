---Implements extended hover functionality
---(e.g. vscode like `editor.action.showDefinitionPreviewHover`)

local ms = vim.lsp.protocol.Methods
local M = { servers = { "tsserver", "typescript-tools" } }

function M.extended_hover()
  local start_buf = vim.api.nvim_get_current_buf()

  local clients = vim.lsp.get_clients({ bufnr = start_buf })
  local client ---@type vim.lsp.Client

  for _, c in ipairs(clients) do
    if
      vim.tbl_contains(M.servers, c.name)
      and c.supports_method(ms.textDocument_hover)
      and c.supports_method(ms.textDocument_definition)
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
      local max_width = math.floor(vim.o.columns * 0.4)
      -- TODO: handle empty table
      local longest_line = math.max(unpack(vim.iter(content):map(string.len):totable()))
      if longest_line > max_width then
        longest_line = max_width
      end

      table.insert(content, #lines.hover + 1, (""):rep(longest_line))
      vim.lsp.util.open_floating_preview(content, "markdown", {
        border = PREF.ui.border,
        max_height = math.floor(vim.o.lines * 0.5),
        max_width = max_width,
        focus_id = "ext_hover",
      })
    end)
  end)

  local params = vim.lsp.util.make_position_params()

  -- HOVER
  client.request(ms.textDocument_hover, params, function(err, result, ctx, config)
    if err or not result or vim.tbl_isempty(result) or ctx.bufnr ~= start_buf then
      vim.notify("Problem in hover request in ext_hover", vim.log.levels.INFO)
      handle_result({ hover = {} })
      return
    end

    vim.print(result.contents)

    local value = ""
    if vim.islist(result.contents) then
      -- E.g. `typescript-tools` in a `hover` structure has `{ { kind = "markdown", value = ... }, 'some string description }`
      for _, v in ipairs(result.contents) do
        value = value .. "\n" .. (v.value or type(v) == "string" and v or "")
      end
    else
      value = result.contents.value
    end

    local content = vim.split(value, "\n", { trimempty = true })
    handle_result({ hover = content })
  end, start_buf)

  ---Get certain lines from a file
  ---@param path string
  ---@param startline integer
  ---@param endline integer
  ---@return string[]
  local function get_lines(path, startline, endline)
    local file = io.open(path, "r")
    if not file then
      return {}
    end
    local lines = vim.iter(file:lines()):skip(startline - 1):take(endline - (startline - 1)):totable()
    file:close()
    return lines
  end

  ---Trim indent of each line according to the first line
  ---@param lines string[]
  ---@return string[]
  local function trim_indent(lines)
    local indent = lines[1]:match("^(%s*)")
    for i, line in ipairs(lines) do
      if vim.startswith(line, indent) then
        lines[i] = line:sub(#indent + 1)
      end
    end
    return lines
  end

  ---Wrap the lines in a markdown code block. If lines is empty, return an empty table
  ---@param path string
  ---@param lines string[]
  ---@return string[]
  local function wrap_md(path, lines)
    if vim.tbl_isempty(lines) then
      return lines
    end
    local ft = vim.filetype.match({ filename = path })
    if not ft or ft == "" then
      ft = vim.fn.fnamemodify(path, ":e")
    end
    return vim.tbl_flatten({ "```" .. ft, lines, "```" })
  end

  -- DEFINITION
  client.request(ms.textDocument_definition, params, function(err, result, ctx, config)
    if err or not result or vim.tbl_isempty(result) or ctx.bufnr ~= start_buf then
      handle_result({ definition = {} })
      vim.notify("Problem in definition request in ext_hover", vim.log.levels.INFO)
      return
    end

    local def = result[1]

    local path = vim.uri_to_fname(def.targetUri)
    local start_line = def.targetRange.start.line + 1
    local end_line = def.targetRange["end"].line + 1
    local lines = get_lines(path, start_line, end_line)
    lines = trim_indent(lines)

    handle_result({
      definition = wrap_md(path, lines),
    })
  end, start_buf)
end

return M
