-- local stl = require('modules.statusline')
local textwidth = PREF.common.textwidth
local tabwidth = PREF.common.tabwidth

local function escape(str)
  local escape_chars = [[;,."|\]]
  return vim.fn.escape(str, escape_chars)
end

local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]
local langmap = vim.fn.join({
  escape(ru_shift) .. ';' .. escape(en_shift),
  escape(ru) .. ';' .. escape(en),
}, ',')

-- To display the `number` in the `statuscolumn` according to
-- the `number` and `relativenumber` options and their combinations
_G.__number = function()
  local nu = vim.opt.number:get()
  local rnu = vim.opt.relativenumber:get()
  local cur_line = vim.fn.line('.') == vim.v.lnum and vim.v.lnum or vim.v.relnum

  if nu and rnu then
    return cur_line
  elseif nu then
    return vim.v.lnum
  elseif rnu then
    return vim.v.relnum
  end

  return ''
end

-- To display pretty fold's icons in `statuscolumn` and show it according to `fillchars`
_G.__foldcolumn = function()
  local chars = vim.opt.fillchars:get()
  local fc = '%#FoldColumn#'
  local clf = '%#CursorLineFold#'
  local hl = vim.fn.line('.') == vim.v.lnum and clf or fc

  if vim.fn.foldlevel(vim.v.lnum) > vim.fn.foldlevel(vim.v.lnum - 1) then
    if vim.fn.foldclosed(vim.v.lnum) == -1 then
      return hl .. (chars.foldopen or ' ')
    else
      return hl .. (chars.foldclose or ' ')
    end
  elseif vim.fn.foldlevel(vim.v.lnum) == 0 then
    return hl .. ' '
  else
    return hl .. (chars.foldsep or ' ')
  end
end

local options = {
  -- ==========================================================================
  -- Indents, spaces, tabulation
  -- ==========================================================================
  expandtab = true,
  cindent = true,
  smarttab = true,
  shiftwidth = tabwidth,
  tabstop = tabwidth,

  -- ==========================================================================
  -- UI
  -- ==========================================================================
  number = true,
  relativenumber = true,
  termguicolors = true,
  showmode = false,
  showcmd = false,
  cmdheight = 1,
  pumheight = 10,
  showtabline = 0,
  cursorline = true,
  numberwidth = 3,
  signcolumn = 'yes',
  scrolloff = 3,
  sidescrolloff = 3,
  colorcolumn = tostring(textwidth),
  laststatus = 3,
  fillchars = {
    eob = ' ',
    fold = ' ',
    foldopen = '',
    foldclose = '',
    foldsep = ' ', -- or "│" to use bar for show fold area
  },
  title = false,
  -- statusline = stl,

  -- ==========================================================================
  -- Text
  -- ==========================================================================
  textwidth = PREF.common.textwidth,
  wrap = false,
  linebreak = true,

  -- ==========================================================================
  -- Search
  -- ==========================================================================
  ignorecase = true,
  smartcase = true,
  hlsearch = true,
  infercase = true,
  grepprg = 'rg --vimgrep',

  -- ==========================================================================
  -- Folding
  -- ==========================================================================
  foldcolumn = '1',
  foldlevel = 99,
  foldlevelstart = 99,
  foldenable = true,
  foldmethod = 'expr',
  foldexpr = 'v:lua.vim.treesitter.foldexpr()',
  statuscolumn = vim.fn.join({
    '%s%=',
    '%{v:lua.__number()}',
    ' %{%v:lua.__foldcolumn()%} ',
  }, ''),

  -- ==========================================================================
  -- Other
  -- ==========================================================================
  updatetime = 1000,
  undofile = true,
  splitright = true,
  splitbelow = true,
  mouse = 'a',
  clipboard = 'unnamedplus',
  backup = false,
  swapfile = false,
  completeopt = { 'menuone', 'noselect' },
  winbar = ' ',
  spell = false,
  spelllang = 'en_us,ru_ru',
  whichwrap = vim.opt.whichwrap:append('<,>,[,],h,l'),
  shortmess = vim.opt.shortmess:append('c'),
  iskeyword = vim.opt.iskeyword:append('-'),
  langmap = langmap,
  smoothscroll = true,
}

for option_name, value in pairs(options) do
  -- To avoid errors on toggle nvim version
  if vim.opt[option_name] ~= nil then
    vim.opt[option_name] = value
  end
end
