local function map(mode, new_keys, to_do, options)
  local keymap = vim.keymap.set
  local default_options = {
    noremap = true,
    silent = true,
    expr = false,
  }

  if options then
    default_options = vim.tbl_deep_extend('force', default_options, options)
  end

  local ok, _ = pcall(keymap, mode, new_keys, to_do, default_options)
  if not ok then
    local msg = 'Fail to mapping ' .. new_keys .. ' for ' .. to_do
    vim.notify(msg, vim.log.levels.ERROR, { title = 'Keymap' })
  end
end

local function toggle_diagnostics()
  local state = PREF.lsp.show_diagnostic
  PREF.lsp.show_diagnostic = not state
  if state then
    vim.diagnostic.disable()
    return
  end
  vim.diagnostic.enable()
end

-- Установка лидера
map('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ';'

-- 'jk' как <Esc>, удобная смена режима
map('i', 'jk', '<Esc>')

-- закрыть nvim
map('n', '<leader>q', ':qa<CR>')

-- терминальные клавиши (для использования в режиме INSERT)
map('i', '<C-f>', '<Right>')
map('i', '<C-b>', '<Left>')
map('i', '<C-a>', '<Home>')
map('i', '<C-e>', '<End>')
map('i', '<C-d>', '<Delete>')

-- К первому не пробельному символу
map('n', 'H', '^')
map('v', 'H', '^')
map('x', 'H', '^')
-- К последнему символу
map('n', 'L', '$')
map('v', 'L', '$')
map('x', 'L', '$')

-- Закрытие окна
map('n', 'q', ':close<CR>')

-- Открыть файл под курсором vsplit
map('n', 'sg', ':vertical wincmd f<CR>')

-- Передвижение по окнам
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Поменять окна местами
map('n', 'wr', '<C-w>x')

-- К следующему буферу
map('n', 'bn', ':bn<CR>')
-- К предыдущему буферу
map('n', 'bp', ':bp<CR>')

-- Не копировать при удалении
map('n', 'x', '"_x')
map('x', 'x', '"_x')

-- Замена текста без копирования в клипборд
map('x', 'p', '"_c<esc>p')

-- К парной скобке
map('n', '<BS>', '%')

-- Новая строка под курсором в любой позиции в режиме ввода
map('i', '<S-CR>', '<C-o>o')

-- Добавить/убрать табуляцию
map('x', '<', '<gv')
map('x', '>', '>gv|')
map('x', '<S-TAB>', '<gv')
map('x', '<TAB>', '>gv|')

-- Сохранить изменения
map('n', '<C-s>', '<esc><cmd>w<CR>')
map('i', '<C-s>', '<esc><cmd>w<CR>')
map('v', '<C-s>', '<esc><cmd>w<CR>')
map('x', '<C-s>', '<esc><cmd>w<CR>')

-- Перемещение строк вверх/вниз
map('x', '<C-n>', ":move'>+<CR>gv=gv")
map('x', '<C-p>', ":move'<-2<CR>gv=gv")
map('n', '<C-n>', '<cmd>move+1<CR>==')
map('n', '<C-p>', '<cmd>move-2<CR>==')

-- Дублировать строку под курсором
map('n', '<leader>d', 'Vm`""Y""PgV``')
map('x', '<leader>d', '""Y""Pgv')

-- Макросы
map('n', 'Q', 'q')
map('n', 'gQ', '@q')

-- Показать/скрыть сообщения диагностики в signcolumn
map('n', '<leader>td', toggle_diagnostics)

-- Открыть файл настроек
map('n', '<leader>cn', ':vert e ~/.config/nvim/init.lua<CR>')

-- Заменить значение слова на противоположное
map('n', '<leader>i', require('modules.toggler').toggle_cword_at_cursor)

-- ========= Привязки для плагинов

-- NvimTree, NeoTree
local file_explorers = {
  ['nvim-tree'] = 'NvimTreeToggle',
  ['neo-tree'] = 'NeoTreeFocusToggle',
}

local fm_ok, _ = pcall(require, PREF.file_explorer)

if fm_ok then
  local ex = file_explorers[PREF.file_explorer]
  map('n', '<localleader>e', ':' .. ex .. ' <CR>')
else
  map('n', '<localleader>e', ':Lex 20<CR>')
end

-- nvim-notify
map('n', '<leader>a', ':Notifications<CR>')

-- Telescope
local telescope_ok, telescope = pcall(require, 'telescope.builtin')
if telescope_ok then
  local builtin = require('telescope.builtin')
  map('n', '<localleader>f', builtin.find_files)
  map('n', '<localleader>g', builtin.live_grep)
  map('n', '<localleader>b', builtin.buffers)
  map('n', '<localleader>d', ':Telescope diagnostics<CR>')
  map('n', '<localleader>o', builtin.oldfiles)
  map('n', '<localleader>n', ':Telescope notify<CR>')
  map('n', '<localleader>;', builtin.current_buffer_fuzzy_find)
  map('n', '<localleader>s', function()
    telescope.live_grep({ default_text = vim.fn.expand('<cword>') })
  end)
  map('n', '<localleader>p', function()
    telescope.find_files({
      default_text = vim.fn.expand('<cword>'),
    })
  end)
end

-- Gitsigns
local gitsigns_ok, _ = pcall(require, 'gitsigns')
if gitsigns_ok then
  map('n', '<leader>gp', ':Gitsigns prev_hunk<CR>')
  map('n', '<leader>gn', ':Gitsigns next_hunk<CR>')
  map('n', '<leader>gs', ':Gitsigns preview_hunk<CR>')
  map('n', '<leader>gd', ':Gitsigns diffthis<CR>')
  map('n', '<leader>ga', ':Gitsigns stage_hunk<CR>')
  map('n', '<leader>gr', ':Gitsigns reset_hunk<CR>')
  map('n', '<leader>gA', ':Gitsigns stage_buffer<CR>')
  map('n', '<leader>gR', ':Gitsigns reset_buffer<CR>')
end

-- Neogen
local neogen_ok, _ = pcall(require, 'neogen')
if neogen_ok then
  map('n', '<localleader>a', ':Neogen<CR>')
end
