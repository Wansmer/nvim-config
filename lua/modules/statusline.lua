local u = require('utils')
_G.gitinfo = u.git_status()

local function lsp_list()
  local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
  local buf_client_names = {}

  -- Получает все клиенты LSP, которые не null-ls
  for _, client in pairs(buf_clients) do
    if client.name ~= 'null-ls' then
      table.insert(buf_client_names, client.name)
    end
  end

  return table.concat(buf_client_names, ', ')
end

local function formatters_list()
  local formatters = require('config.lsp.formatters')
  local buf_ft = vim.bo.filetype
  local supported_formatters = formatters.list_registered(buf_ft)
  return table.concat(supported_formatters, ', ')
end

_G.__stl = {
  mode = function()
    local modes = { ['n'] = 'DiffText', ['i'] = 'IncSearch', ['v'] = 'Search', ['r'] = 'Substitute' }
    local mode = modes[vim.fn.strtrans(vim.fn.mode()):lower():gsub('%W', '')] or 'DiffText'
    return '%#' .. mode .. '# %*'
  end,
  filename = function()
    local icon = ''
    local ok, di = pcall(require, 'nvim-web-devicons')
    if ok then
      icon, _ = di.get_icon_color_by_filetype(vim.bo.filetype, { default = true })
    end
    local res = '%t'
    return icon .. ' ' .. res .. '%*'
  end,
  branch = function()
    local info = _G.gitinfo
    return ' ' .. info.branch
  end,
  ts = function()
    local icon = ''
    local buf = vim.api.nvim_get_current_buf()
    local highlighter = require('vim.treesitter.highlighter')
    local hl = '%#WinSeparator#' .. icon .. ' TS%*'
    if highlighter.active[buf] then
      hl = '%#String#' .. icon .. '%*' .. '%#Text# TS%*'
    end
    return hl
  end,
  lsp = function()
    local lsp = lsp_list()
    local text = ' LSP:'
    if lsp == '' then
      text = '%#WinSeparator#' .. text .. '%*'
    end
    return vim.trim(vim.fn.join({ text, lsp }, ' '))
  end,
  formatters = function()
    local formatters = formatters_list()
    local text = ' Format:'
    if formatters == '' then
      text = '%#WinSeparator#' .. text .. '%*'
    end
    return vim.trim(vim.fn.join({ text, formatters }, ' '))
  end,
}

return vim.fn.join({
  [[%{%v:lua.__stl.mode()%}]],
  [[%{%v:lua.__stl.filename()%}]],
  [[%{%v:lua.__stl.branch()%}]],
  '%=',
  [[%{%v:lua.__stl.lsp()%}]],
  [[%{%v:lua.__stl.formatters()%}]],
  [[%{%v:lua.__stl.ts()%}]],
  ' %l:%c',
  ' %p%%',
  [[%{%v:lua.__stl.mode()%}]],
}, ' %#WinSeparator#| %*')
