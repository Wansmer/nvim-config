local present_navic, _ = pcall(require, 'nvim-navic')

local text_width = 80
local tab_width = 2
local winbar = ''

if present_navic then
  winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
end

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
  -- linebreak = true,
  -- formatoptions = 'l',

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
  -- noswapfile = '',
  completeopt = { 'menuone', 'noselect' },
  winbar = winbar,

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

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function ()
    local ft_ignore = {
      'nvim-tree',
      'neo-tree',
      'pakcer',
    }
    local buf = vim.api.nvim_win_get_buf(0)
    local buftype = vim.api.nvim_buf_get_option(buf, 'ft')
    if vim.tbl_contains(ft_ignore, buftype) then
      return
    end
    local width = vim.api.nvim_win_get_width(0)
    if width < text_width then
      vim.api.nvim_win_set_width(0, text_width)
    end
  end
})

vim.cmd([[
  hi WinSeparator guibg=None
]])
