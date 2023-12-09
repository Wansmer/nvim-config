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
  numberwidth = 3,
  showmode = false,
  showcmd = false,
  cmdheight = 1,
  pumheight = 10,
  showtabline = 0,
  cursorline = true,
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
  statuscolumn = require('modules.status').column(),
  statusline = require('modules.status').line(),

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
  foldtext = require('modules.foldtext'),

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
  local ok, _ = pcall(vim.api.nvim_get_option_info2, option_name, {})
  if ok then
    vim.opt[option_name] = value
  else
    vim.notify('Option ' .. option_name .. ' is not supported', vim.log.levels.WARN)
  end
end
