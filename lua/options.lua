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
  relativenumber = false,
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
  laststatus = 0,
  fillchars = {
    eob = ' ',
    fold = ' ',
  },
  title = false,

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
  statuscolumn = '%s%=%l %#FoldColumn#%{'
    .. 'foldlevel(v:lnum) > foldlevel(v:lnum - 1)'
    .. '? foldclosed(v:lnum) == -1'
    .. '? ""'
    .. ': ""'
    .. ': foldlevel(v:lnum) == 0'
    .. '? " "'
    .. ': " "' -- "│" -- to use bar for show fold area
    .. '} ',

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
}

for option_name, value in pairs(options) do
  vim.opt[option_name] = value
end
