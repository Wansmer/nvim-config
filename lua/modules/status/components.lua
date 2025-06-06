local u = require("utils")
local M = {}

---To display the `number` in the `statuscolumn` according to
---the `number` and `relativenumber` options and their combinations
function M.number()
  local nu = vim.opt.number:get()
  local rnu = vim.opt.relativenumber:get()
  local cur_line = vim.fn.line(".") == vim.v.lnum and vim.v.lnum or vim.v.relnum

  -- Repeats the behavior for `vim.opt.numberwidth`
  local width = vim.opt.numberwidth:get()
  local l_count_width = #tostring(vim.api.nvim_buf_line_count(0))
  -- If buffer have more lines than `vim.opt.numberwidth` then use width of line count
  width = width >= l_count_width and width or l_count_width

  local function pad_start(n)
    local len = width - #tostring(n)
    return len < 1 and n or (" "):rep(len) .. n
  end

  local v_hl = ""

  local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")
  local cur = vim.api.nvim_win_get_cursor(0)
  if mode == "v" and cur[1] ~= vim.v.lnum then
    local v_range = u.get_visual_range()
    local is_in_range = vim.v.lnum >= v_range[1] and vim.v.lnum <= v_range[3]
    v_hl = is_in_range and "%#VisualRangeNr#" or ""
  end

  if nu and rnu then
    return v_hl .. pad_start(cur_line)
  elseif nu then
    return v_hl .. pad_start(vim.v.lnum)
  elseif rnu then
    return v_hl .. pad_start(vim.v.relnum)
  end

  return ""
end

---To display pretty fold's icons in `statuscolumn` and show it according to `fillchars`
function M.foldcolumn()
  local chars = vim.opt.fillchars:get()
  local fc = "%#FoldColumn#"
  local clf = "%#CursorLineFold#"
  local hl = vim.fn.line(".") == vim.v.lnum and clf or fc
  local text = " "

  if vim.fn.foldlevel(vim.v.lnum) > vim.fn.foldlevel(vim.v.lnum - 1) then
    if vim.fn.foldclosed(vim.v.lnum) == -1 then
      text = hl .. (chars.foldopen or " ")
    else
      text = hl .. (chars.foldclose or " ")
    end
  elseif vim.fn.foldlevel(vim.v.lnum) == 0 then
    text = hl .. " "
  else
    text = hl .. (chars.foldsep or " ")
  end

  return text
end

local function lsp_list()
  local get_clients = vim.fn.has("nvim-0.10") == 1 and vim.lsp.get_clients or vim.lsp.get_active_clients
  local buf_clients = get_clients({ bufnr = 0 })
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    table.insert(buf_client_names, client.name)
  end

  return table.concat(buf_client_names, ", ")
end

local function formatters_list()
  local ok, conform = pcall(require, "conform")
  if not ok then
    return ""
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local formatters = conform.list_formatters(bufnr)
  local function get_name(item)
    return item.name
  end

  if vim.fn.has("nvim-0.10") ~= 1 then
    return vim.fn.join(vim.tbl_map(get_name, formatters), ", ")
  end

  return vim.iter(formatters):map(get_name):join(", ")
end

function M.lsp()
  local lsp = lsp_list()
  local prefix = (lsp == "" and " no lsp" or "%#LSPStatusActive#%*")
  return vim.trim(vim.fn.join({ prefix, lsp }, " "))
end

function M.formatters()
  local formatters = formatters_list()
  local prefix = (formatters == "" and "󰉩 no formatters" or "%#FormatterStatusActive#󰉩%*")
  return vim.trim(vim.fn.join({ prefix, formatters }, " "))
end

function M.cur_mode()
  -- TODO: find better hls
  local modes = { ["n"] = "NormalStatus", ["i"] = "InsertStatus", ["v"] = "VisualStatus", ["r"] = "ReplaceStatus" }
  local mode = modes[vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")] or "DiffText"
  return "%#" .. mode .. "# %*"
end

function M.filename()
  local icon = ""
  local hl = ""
  local ok, di = pcall(require, "nvim-web-devicons")
  if ok then
    icon, hl = di.get_icon_by_filetype(vim.bo.filetype, { default = true })
    icon = "%#" .. hl .. "#" .. icon .. "%*"
  end
  return icon .. " %t"
end

function M.treesitter()
  local icon = ""
  local buf = vim.api.nvim_get_current_buf()
  local ok, _ = pcall(vim.treesitter.get_parser, buf)
  icon = ok and "%#TSStatusActive#" .. icon .. "%*" or icon
  return icon .. " TS"
end

function M.branch()
  local icon = " "
  if not (vim.g.__git_branch or vim.g.__git_dirty) or vim.g.__git_branch == "" then
    return icon .. "no git"
  end
  local head = vim.g.__git_branch
  if vim.g.__git_dirty then
    icon = "%#StatusGitDirty#" .. icon .. "%*"
  else
    icon = "%#StatusGitClean#" .. icon .. "%*"
  end
  return icon .. head
end

function M.navic()
  local ok, navic = pcall(require, "nvim-navic")
  if ok and navic.is_available() then
    return navic.get_location()
  end
  return ""
end

function M.win_info()
  local win = vim.api.nvim_get_current_win()
  local is_float = vim.api.nvim_win_get_config(win).relative ~= ""
  local prev_win = vim.fn.win_getid(vim.fn.winnr("#"))
  return string.format("%s %d. Prev: %d", is_float and "float" or "win", win, prev_win)
end

return M
