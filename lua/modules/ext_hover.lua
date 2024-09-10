---Implements extended hover functionality
---(e.g. vscode like `editor.action.showDefinitionPreviewHover`)

local u = require("utils")
local Promise = require("promise")
local ms = vim.lsp.protocol.Methods
local M = {
  servers = {
    "tsserver",
    "vtsls",
    "typescript-tools",
    "lua_ls",
    "pyright",
    "basedpyright",
  },
}

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

  local params = vim.lsp.util.make_position_params()

  -- HOVER
  local get_hover = function()
    return Promise.new(function(resolve)
      client.request(ms.textDocument_hover, params, function(err, result, ctx, config)
        if err or not result or vim.tbl_isempty(result) or ctx.bufnr ~= start_buf then
          vim.notify("Problem in hover request in ext_hover", vim.log.levels.INFO)
          return
        end

        local value = ""
        if vim.islist(result.contents) then
          -- E.g. `typescript-tools` in a `hover` structure has `{ { kind = "markdown", value = ... }, 'some string description }`
          for _, v in ipairs(result.contents) do
            value = value .. "\n" .. (v.value or type(v) == "string" and v or "")
          end
        else
          -- E.g. `vtsls` hasn't `.value`, `contents` just is a string
          value = type(result.contents) == "string" and result.contents or result.contents.value
        end

        if not value then
          return
        end

        local content = vim.split(value, "\n", { trimempty = true })
        resolve(content)
      end, start_buf)
    end)
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
  local get_definition = function()
    return Promise.new(function(resolve)
      client.request(ms.textDocument_definition, params, function(err, result, ctx, config)
        if err or not result or vim.tbl_isempty(result) or ctx.bufnr ~= start_buf then
          vim.notify("Problem in definition request in ext_hover", vim.log.levels.INFO)
          return
        end

        local def = result[1]

        local path = vim.uri_to_fname(def.targetUri or def.uri) -- e.g. pyright has no `targetUri` but `uri`
        local range = def.targetRange or def.range -- e.g. pyright has no `targetRange` but `range`
        local start_line = range.start.line + 1
        local end_line = range["end"].line + 1
        local lines = u.get_lines(path, start_line, end_line)
        lines = u.trim_indent(lines)

        resolve(wrap_md(path, lines))
      end, start_buf)
    end)
  end

  Promise.all_settled({ get_hover(), get_definition() }):next(function(results)
    local lines = vim
      .iter(results)
      :filter(function(v)
        return v.status == "fulfilled"
      end)
      :map(function(v)
        return v.value
      end)
      :flatten()
      :totable()

    local max_width = math.floor(vim.o.columns * 0.4)
    -- TODO: handle empty table
    local longest_line = math.max(unpack(vim.iter(lines):map(string.len):totable()))
    if longest_line > max_width then
      longest_line = max_width
    end

    -- TODO: insert breaklines only if status is fulfilled
    table.insert(lines, #results[1].value + 1, (""):rep(longest_line))
    vim.lsp.util.open_floating_preview(lines, "markdown", {
      border = PREF.ui.border,
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = max_width,
      focus_id = "ext_hover",
    })
  end)
end

return M
