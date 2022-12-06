local textwidth = PREF.common.textwidth
local tabwidth = PREF.common.tabwidth
local winbar = ''

local options = {
  -- ==========================================================================
  -- Табуляция и отступы | Indents, spaces, tabulation
  -- ==========================================================================
  expandtab = true,
  cindent = true,
  smarttab = true,
  shiftwidth = tabwidth,
  tabstop = tabwidth,

  -- ==========================================================================
  -- Визуальное оформление | UI
  -- ==========================================================================
  number = true,
  relativenumber = false,
  termguicolors = true,
  showmode = false,
  showcmd = false,
  cmdheight = 2,
  pumheight = 10,
  showtabline = 0,
  cursorline = true,
  numberwidth = 3,
  signcolumn = 'yes',
  scrolloff = 3,
  sidescrolloff = 3,
  colorcolumn = tostring(textwidth),
  laststatus = 3,
  fillchars = [[eob: ,foldsep: ,foldopen:,foldclose:]],
  title = false,

  -- ==========================================================================
  -- Текст | Text
  -- ==========================================================================
  textwidth = 0,
  wrap = false,
  linebreak = false,

  -- ==========================================================================
  -- Поиск | Search
  -- ==========================================================================
  ignorecase = true,
  smartcase = true,
  hlsearch = true,

  -- ==========================================================================
  -- Фолдинг | Folding
  -- ==========================================================================
  foldcolumn = '1',
  foldnestmax = 1,
  foldminlines = 0,
  foldlevel = 99,
  foldlevelstart = 99,
  foldmethod = 'indent',
  foldenable = true,

  -- ==========================================================================
  -- Прочее | Other
  -- ==========================================================================
  updatetime = 300,
  undofile = true,
  splitright = true,
  splitbelow = true,
  mouse = 'a',
  clipboard = 'unnamedplus',
  backup = false,
  swapfile = false,
  completeopt = { 'menuone', 'noselect' },
  winbar = winbar,
  spell = false,
  spelllang = 'en_us,ru_ru',
  whichwrap = vim.opt.whichwrap:append('<,>,[,],h,l'),
  shortmess = vim.opt.shortmess:append('c'),
  iskeyword = vim.opt.iskeyword:append('-'),
}

for option_name, value in pairs(options) do
  vim.opt[option_name] = value
end
