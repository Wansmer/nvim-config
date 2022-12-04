local text_width = PREF.common.text_width
local tab_width = PREF.common.tab_width
local winbar = ''

local options = {
  -- ==========================================================================
  -- Табуляция и отступы | Indents, spaces, tabulation
  -- ==========================================================================
  expandtab = true,
  cindent = true,
  smarttab = true,
  shiftwidth = tab_width,
  tabstop = tab_width,

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
  colorcolumn = tostring(text_width),
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
