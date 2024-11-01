local u = require("utils")

local store = {}

local function set_hls()
  local vhl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
  local ihl = vim.api.nvim_get_hl(0, { name = "LspInlayHint", link = false })
  vim.api.nvim_set_hl(0, "VisualLspInlayHint", { bg = vhl.bg, fg = ihl.fg })
end
set_hls()

---Set hl to virtual text list in place
---@param virt_text {[1]: string, [2]: string?}[]
---@param hl string
local function set_virt_hl_value(virt_text, hl)
  for _, tuple in ipairs(virt_text) do
    tuple[2] = hl
  end
end

---Update extmark
---@param ns integer
---@param mark_id integer
---@param opts {virt_text: {[1]: string, [2]: string?}[], hl: string, line: integer, col: integer, hl: string}}
---@return boolean, any
local function update_marks(ns, mark_id, opts)
  set_virt_hl_value(opts.virt_text, opts.hl)
  -- Mark may be deleted by other script, e.g. default Inlay-hint handler
  return pcall(vim.api.nvim_buf_set_extmark, 0, ns, opts.line, opts.col, {
    id = mark_id,
    virt_text = opts.virt_text,
    virt_text_pos = "inline",
  })
end

---Restore extmarks for a given range or all if nil
---@param range? number[]
local function restore_marks(range)
  local ihns = vim.api.nvim_get_namespaces()["vim_lsp_inlayhint"]

  for id, data in pairs(store) do
    if not range or not (data.line >= range[1] - 1 and data.line <= range[3] - 1) then
      set_virt_hl_value(data.virt_text, "LspInlayHint")
      data.hl = "LspInlayHint"
      update_marks(ihns, id, data)
      store[id] = nil
    end
  end
end

vim.api.nvim_create_autocmd({ "ModeChanged", "CursorMoved" }, {
  callback = function()
    local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")
    local ihns = vim.api.nvim_get_namespaces()["vim_lsp_inlayhint"]
    if mode ~= "v" or not ihns then
      restore_marks()
      return
    end

    local range = u.get_visual_range()
    local marks = vim.api.nvim_buf_get_extmarks(0, ihns, { range[1] - 1, 0 }, { range[3], 0 }, { details = true })

    for _, m in ipairs(marks) do
      local id, linenr, col, opts = m[1], m[2], m[3], m[4]
      set_virt_hl_value(m[4].virt_text, "VisualLspInlayHint")

      if not store[m[1]] then
        local data = { line = linenr, col = col, virt_text = opts.virt_text, hl = "VisualLspInlayHint" }
        local ok, _ = update_marks(ihns, id, data)
        if ok then
          store[id] = data
        end
      end
    end

    restore_marks(range)
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_hls,
})
