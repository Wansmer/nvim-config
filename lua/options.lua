local text_width = 120
local tab_width = 2
local winbar = ''

local options = {
  -- ==========================================================================
  -- Табуляция и отступы | Indents, spaces, tabulation
  -- ==========================================================================
  expandtab = true,
  smartindent = true,
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
  signcolumn = 'number',
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
  foldcolumn = '0',
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
  -- noswapfile = '',
  completeopt = { 'menuone', 'noselect' },
  winbar = winbar,
  spell = false,
  spelllang = 'en_us,ru_ru',
}

vim.opt.shortmess:append('c')

for option_name, value in pairs(options) do
  vim.opt[option_name] = value
end

-- Каким командам можно перескакивать на новую строку с окончания предыдущей
vim.cmd('set whichwrap+=<,>,[,],h,l')

-- Задает, что считать словом
vim.cmd([[set iskeyword+=-]])

-- Отключение автокомментирования новой строки
vim.cmd([[au BufEnter * set formatoptions-=cro]])

-- Подсветить скопированное
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 100 })
  end,
})

-- Установливать активному окну ширину не менее text_width
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local ft_ignore = {
      'nvim-tree',
      'neo-tree',
      'packer',
      'aerial',
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
  end,
})

-- Убрать сепаратор между окнами
vim.cmd([[hi WinSeparator guibg=None]])
