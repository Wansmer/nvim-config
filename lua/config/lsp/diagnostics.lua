local u = require("utils")
local NS = vim.api.nvim_create_namespace("__part.diagnostics")

local function set_float_hls()
  local fb = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = false })
  local ws = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })

  local set_hl = vim.api.nvim_set_hl

  set_hl(NS, "FloatBorder", { fg = ws.fg, bg = fb.bg })
  -- Safe your eyes. Reading SCREAMING RED TEXT is bad
  set_hl(NS, "DiagnosticFloatingWarn", { link = "NormalFloat" })
  set_hl(NS, "DiagnosticFloatingError", { link = "NormalFloat" })
  set_hl(NS, "DiagnosticFloatingInfo", { link = "NormalFloat" })
  set_hl(NS, "DiagnosticFloatingHint", { link = "NormalFloat" })
end

local severitySigns = {
  [vim.diagnostic.severity.ERROR] = "",
  [vim.diagnostic.severity.WARN] = "",
  [vim.diagnostic.severity.HINT] = "",
  [vim.diagnostic.severity.INFO] = "",
}

---@type vim.diagnostic.Opts
local config = {
  virtual_text = PREF.lsp.virtual_text,
  signs = {
    text = severitySigns,
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = false,
    focusable = true,
    style = "minimun",
    -- border = PREF.ui.border, ---@type string|table
    prefix = function(d)
      local severity_name = u.capitalize(vim.diagnostic.severity[d.severity])
      return severitySigns[d.severity] .. " ", "DiagnosticSign" .. severity_name
    end,
    format = function(d)
      return d.message .. " "
    end,
    suffix = function(d)
      return string.format("[%s: %s]", d.source, d.code), "Underlined"
    end,
    header = "",
    ---@type string|string[]|table<number, [string, string]>
    border = {
      { "", "FloatBorder" },
      { "", "FloatBorder" },
      { "", "FloatBorder" },
      { " ", "FloatBorder" },
      { "", "FloatBorder" },
      { "", "FloatBorder" },
      { "", "FloatBorder" },
      { " ", "FloatBorder" },
    },
  },
}

local M = {}

function M.toggle_diagnostics()
  vim.diagnostic.enable(vim.diagnostic.is_enabled())
end

function M.apply()
  local orig_open_float = vim.diagnostic.open_float
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.diagnostic.open_float = function(opts, ...)
    local _, win = orig_open_float(opts, ...)
    vim.api.nvim_win_set_hl_ns(win--[[@as integer]], NS)

    vim.keymap.set("n", "K", function()
      local col = vim.api.nvim_win_get_cursor(0)[2] + 1
      local from, to, url = vim.api.nvim_get_current_line():find("%[(.-)%]")
      if from and col >= from and col <= to then
        url = "https://ya.ru/search?text=" .. u.encodeURL(url)
        vim.system({ "open", url }, nil, function(res)
          if res.code ~= 0 then
            vim.notify("Failed to open URL" .. url, vim.log.levels.ERROR)
          end
        end)
      end
    end, { buffer = true, silent = true })
  end

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_float_hls,
  })

  set_float_hls()

  vim.diagnostic.config(config)

  local signs = {
    Error = config.signs.text[vim.diagnostic.severity.ERROR],
    Warn = config.signs.text[vim.diagnostic.severity.WARN],
    Hint = config.signs.text[vim.diagnostic.severity.HINT],
    Info = config.signs.text[vim.diagnostic.severity.INFO],
  }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

return M
