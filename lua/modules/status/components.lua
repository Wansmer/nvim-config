local C = {}

---To display the `number` in the `statuscolumn` according to
---the `number` and `relativenumber` options and their combinations
function C.number()
  local nu = vim.opt.number:get()
  local rnu = vim.opt.relativenumber:get()
  local cur_line = vim.fn.line('.') == vim.v.lnum and vim.v.lnum or vim.v.relnum

  -- Repeats the behavior for `vim.opt.numberwidth`
  local width = vim.opt.numberwidth:get()
  local l_count_width = #tostring(vim.api.nvim_buf_line_count(0))
  -- If buffer have more lines than `vim.opt.numberwidth` then use width of line count
  width = width >= l_count_width and width or l_count_width

  local function pad_start(n)
    local len = width - #tostring(n)
    return len < 1 and n or (' '):rep(len) .. n
  end

  if nu and rnu then
    return pad_start(cur_line)
  elseif nu then
    return pad_start(vim.v.lnum)
  elseif rnu then
    return pad_start(vim.v.relnum)
  end

  return ''
end

---To display pretty fold's icons in `statuscolumn` and show it according to `fillchars`
function C.foldcolumn()
  local chars = vim.opt.fillchars:get()
  local fc = '%#FoldColumn#'
  local clf = '%#CursorLineFold#'
  local hl = vim.fn.line('.') == vim.v.lnum and clf or fc
  local text = ' '

  if vim.fn.foldlevel(vim.v.lnum) > vim.fn.foldlevel(vim.v.lnum - 1) then
    if vim.fn.foldclosed(vim.v.lnum) == -1 then
      text = hl .. (chars.foldopen or ' ')
    else
      text = hl .. (chars.foldclose or ' ')
    end
  elseif vim.fn.foldlevel(vim.v.lnum) == 0 then
    text = hl .. ' '
  else
    text = hl .. (chars.foldsep or ' ')
  end

  return text
end

local function lsp_list()
  local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
  local buf_client_names = {}

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

function C.lsp()
  local lsp = lsp_list()
  local prefix = (lsp == '' and ' no lsp' or '%#LSPStatusActive#%*')
  return vim.trim(vim.fn.join({ prefix, lsp }, ' '))
end

function C.formatters()
  local formatters = formatters_list()
  local prefix = (formatters == '' and ' no formatters' or '%#FormatterStatusActive#%*')
  return vim.trim(vim.fn.join({ prefix, formatters }, ' '))
end

function C.cur_mode()
  -- TODO: find better hls
  local modes = { ['n'] = 'NormalStatus', ['i'] = 'InsertStatus', ['v'] = 'VisualStatus', ['r'] = 'ReplaceStatus' }
  local mode = modes[vim.fn.strtrans(vim.fn.mode()):lower():gsub('%W', '')] or 'DiffText'
  return '%#' .. mode .. '# %*'
end

function C.filename()
  local icon = ''
  local ok, di = pcall(require, 'nvim-web-devicons')
  if ok then
    icon, _ = di.get_icon_by_filetype(vim.bo.filetype, { default = true })
  end
  local fname = '%t'
  return icon .. ' ' .. fname .. '%*'
end

function C.treesitter()
  local highlighter = require('vim.treesitter.highlighter')
  local buf = vim.api.nvim_get_current_buf()
  return (highlighter.active[buf] and '%#TSStatusActive#%*' or '') .. ' TS'
end

function C.branch()
  local head = vim.b.gitsigns_head
  return head and (' ' .. head) or ''
end

return C
