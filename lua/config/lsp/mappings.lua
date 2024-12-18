local u = require("utils")
local map = vim.keymap.set

---Add desc for keymap opts
---@param opts table Keymap opts
---@return function(str: string): table
local function desc(opts)
  return function(str)
    opts.desc = str
    return opts
  end
end

local float_opts = {
  border = PREF.ui.border,
  max_width = 80,
}

local M = {}

-- {{ Common lsp dependent toggler
map("n", "<Leader>li", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle inlayHint for current buffer" })
map("n", "<Leader>ld", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = "Toggle diagnostic" })

local function toggle_ltex_lang()
  local client = vim.lsp.get_clients({ name = "ltex", bufnr = 0 })[1]
  if not client then
    return
  end
  local langs = u.tbl_add_reverse_lookup({
    ["ru-RU"] = "en-US",
  })
  local current_lang = client.config.settings.ltex.language
  local lang = langs[current_lang]
  vim.notify("Toggle ltex lang from " .. current_lang .. " to " .. lang, vim.log.levels.INFO, { title = "Ltex:" })
  client.config.settings.ltex.language = lang
  vim.lsp.buf_notify(0, "workspace/didChangeConfiguration", { settings = client.config.settings })
end

vim.keymap.set("n", "<leader>ll", toggle_ltex_lang, { desc = "Toggle ltex language" })
-- }}

-- INFO: Moved out from M.set_keymap since it using third-party format plugin
map("n", "gF", function()
  local ok, conform = pcall(require, "conform")
  if not ok then
    pcall(vim.lsp.buf.format)
    return
  end

  conform.format({ bufnr = 0, lsp_fallback = true })
end, { desc = "Format buffer" })

---Setup mappings
---@param _ table Client
---@param bufnr integer
M.set_keymap = function(_, bufnr)
  local d = desc({ buffer = bufnr, desc = "" })

  -- Diagnostics
  map("n", "gl", function()
    vim.diagnostic.open_float(float_opts)
  end, d("Open diagnostic float on the line"))
  map("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, d("Go to next diagnostic"))
  map("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, d("Go to prev diagnostic"))

  -- Hover (symbol info)
  map("n", "K", function()
    vim.lsp.buf.hover(float_opts)
  end, d("Show symbol info"))
  map("n", "gK", require("modules.ext_hover").extended_hover, d("Show symbol info with definition"))

  -- Formatting
  -- INFO: Moved out from M.set_keymap since it using third-party format plugin

  -- Show code action
  map("n", "ga", vim.lsp.buf.code_action, d("Show available code action"))

  -- Jumps
  map("n", "gd", vim.lsp.buf.definition, d("Go to definition"))
  map("n", "go", vim.lsp.buf.type_definition, d("Go to type definition"))
  map("n", "gD", vim.lsp.buf.declaration, d("Go to declaration"))

  -- Lists
  map("n", "gi", vim.lsp.buf.implementation, d("List of implementation"))
  map("n", "gr", vim.lsp.buf.references, d("List of references"))

  -- Rename
  local ok_lr, lr = pcall(require, "live-rename")
  local renamer = ok_lr and lr.map({
      insert = true, --[[ text = "" ]]
    }) or vim.lsp.buf.rename
  map("n", "gR", renamer, d("Rename symbol"))

  -- Signature help
  map("n", "gs", vim.lsp.buf.signature_help, d("Signature help"))
  map("i", "<C-q>", vim.lsp.buf.signature_help, d("Signature help"))
end

return M
