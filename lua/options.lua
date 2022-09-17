local text_width = 80
local tab_width = 2

local options = {
  -- ==========================================================================
  -- Табуляция и отступы | Indents, spaces, tabulation
  -- ==========================================================================

  expandtab = true,
  smartindent = true,
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

  -- ==========================================================================
  -- Текст | Text
  -- ==========================================================================
  textwidth = text_width,
  wrap = false,

  -- ==========================================================================
  -- Поиск | Search
  -- ==========================================================================
  ignorecase = true,
  smartcase = true,
  hlsearch = true,

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
  completeopt = { 'menuone', 'noselect' },
  -- winbar = '%f',

  -- ==========================================================================
  -- Фолдинг | Folding
  -- ==========================================================================
  foldcolumn = '1',
  foldnestmax = 1,
  foldminlines = 0,
  foldlevel = 99,
  foldlevelstart = 99,
  -- foldmethod = 'indent',
  foldenable = true,
}

vim.opt.shortmess:append('c')

for option_name, value in pairs(options) do
  vim.opt[option_name] = value
end

vim.cmd('set whichwrap+=<,>,[,],h,l')
-- Задает, что считать словом
vim.cmd([[set iskeyword+=-]])
-- Отключение автокомментирования новой строки
vim.cmd([[au BufEnter * set fo-=c fo-=r fo-=o]])
-- Подсветить скопированное
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
  end,
})

vim.cmd([[
  hi WinSeparator guibg=None
]])
