---Additional settings for lsp hover and signature_help
---Based on https://github.com/MariaSolOs/dotfiles/blob/bda5388e484497b8c88d9137c627c0f24ec295d7/.config/nvim/lua/lsp.lua#L193

local ns = vim.api.nvim_create_namespace("__lsp_float__")

local M = {}

M.float_opts = {
  border = PREF.ui.border,
  max_height = math.floor(vim.o.lines * 0.5),
  max_width = math.floor(vim.o.columns * 0.4),
}

local function set_float_hl(buf, win)
  local hls = {
    ["|%S-|"] = "@text.reference",
    ["@%S+"] = "@parameter",
    ["^%s*(Parameters:)"] = "@text.title",
    ["^%s*(Return:)"] = "@text.title",
    ["^%s*(See also:)"] = "@text.title",
    ["{%S-}"] = "@parameter",
  }

  local ok, c = pcall(require, "serenity.colors")
  if ok then
    vim.api.nvim_set_hl(ns, "@text.reference", { fg = c.blue, underline = true })
    vim.api.nvim_win_set_hl_ns(win, ns)
  end

  -- Extra highlights.
  for l, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    for pattern, hl_group in pairs(hls) do
      local from = 1 ---@type integer?
      while from do
        local to
        from, to = line:find(pattern, from)
        if from then
          vim.api.nvim_buf_set_extmark(buf, ns, l - 1, from - 1, {
            end_col = to,
            hl_group = hl_group,
          })
        end
        from = to and to + 1 or nil
      end
    end
  end
end

---Opening help and links with 'K' and 'gx'
---@param buf integer Buffer id
local function set_float_keymaps(buf)
  local function opener()
    -- Vim help links.
    ---@diagnostic disable-next-line: param-type-mismatch
    local tag = (vim.fn.expand("<cWORD>")):match("|(%S-)|")
    if tag then
      return vim.cmd.help(tag)
    end

    -- Markdown links.
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1
    local from, to, url = vim.api.nvim_get_current_line():find("%[.-%]%((%S-)%)")

    if from and col >= from and col <= to then
      vim.system({ "open", url }, nil, function(res)
        if res.code ~= 0 then
          vim.notify("Failed to open URL" .. url, vim.log.levels.ERROR)
        end
      end)
    end
  end

  -- Add keymaps for opening links.
  vim.keymap.set("n", "K", opener, { buffer = buf, silent = true })
  vim.keymap.set("n", "gx", opener, { buffer = buf, silent = true })
end

---LSP handler that adds extra inline highlights, keymaps, and window options.
---Code inspired from [noice](https://github.com/folke/noice.nvim).
---@param handler fun(err: any, result: any, ctx: any, config: any): integer, integer
---@param opts? table
---@return function
local function on_float(handler, opts)
  return function(err, result, ctx, config)
    config = vim.tbl_deep_extend("force", config or {}, opts or {})
    local buf, win = handler(err, result, ctx, vim.tbl_deep_extend("force", config, M.float_opts))

    if not (buf and win) then
      return
    end

    -- Conceal everything.
    vim.wo[win].concealcursor = "n"

    set_float_hl(buf, win)
    set_float_keymaps(buf)
    return buf, win
  end
end

---Improves view of LSP hover and signature_help.
function M.apply()
  local handlers = vim.lsp.handlers
  handlers["textDocument/hover"] = on_float(handlers.hover, { silent = true })
  handlers["textDocument/signatureHelp"] = on_float(handlers.signature_help)
end

return M
