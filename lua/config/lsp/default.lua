-- Default settings for each server
local M = {}

local set_keymaps = require("config.lsp.mappings").set_keymap

---Lsp attach callback
---@param client vim.lsp.Client
---@param bufnr integer
M.on_attach = function(client, bufnr)
  -- Enable formatting for ranges
  if vim.fn.has("nvim-0.10.0") then
    vim.api.nvim_set_option_value("formatexpr", "v:lua.vim.lsp.formatexpr()", { buf = bufnr })
  else
    ---@diagnostic disable-next-line: redundant-parameter
    vim.api.nvim_set_option_value("formatexpr", "v:lua.vim.lsp.formatexpr()", { buf = bufnr })
  end

  local ok_wd, wd = pcall(require, "workspace-diagnostics")
  if ok_wd then
    wd.populate_workspace_diagnostics(client, bufnr)
  end

  -- Disable semantic tokens highlight
  if client.server_capabilities.semanticTokensProvider then
    -- Disable
    -- client.server_capabilities.semanticTokensProvider = nil
    -- Enable
    vim.lsp.semantic_tokens.enable(true, {
      client_id = client.id,
      bufnr = bufnr,
    })
  end

  if client.name == "ltex" then
    local ok, ltex_extra = pcall(require, "ltex_extra")
    if ok then
      ltex_extra.setup({
        -- https://valentjn.github.io/ltex/supported-languages.html#natural-languages
        load_langs = { "en-US", "ru-RU" }, -- en-US as default
        -- boolean : whether to load dictionaries on startup
        init_check = true,
        -- string : relative or absolute path to store dictionaries
        path = vim.fn.stdpath("config") .. "/" .. ".ltex",
        -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
        log_level = "none",
      })
    end
  end

  if client.name == "ruff_lsp" then
    client.server_capabilities.hoverProvider = false
  end

  local ok, sqls = pcall(require, "sqls")
  if ok then
    sqls.on_attach(client, bufnr)
  end

  set_keymaps(client, bufnr)
end

M.autostart = true

M.single_file_support = true

M.flags = { debounce_text_changes = 150 }

-- nvim-cmp
local cmp_ok, cmp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
  local capabilities = cmp.default_capabilities
  -- Luasnip
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  M.capabilities = capabilities
end

return M
