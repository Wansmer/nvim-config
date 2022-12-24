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

-- Перемещение по визуальным строкам как по логическим
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- jk как <ESC>
map('i', PREF.common.escape_keys, '<ESC>')

-- закрыть nvim
map('n', '<leader>q', ':qa<CR>')

-- терминальные клавиши (для использования в режиме INSERT)
map({ 'i', 't', 'c' }, '<C-f>', '<Right>')
map({ 'i', 't', 'c' }, '<C-b>', '<Left>')
map({ 'i', 't', 'c' }, '<C-.>', '<S-Right>')
map({ 'i', 't', 'c' }, '<C-,>', '<S-Left>')
map({ 'i', 't' }, '<C-p>', '<Up>')
map({ 'i', 't' }, '<C-n>', '<Down>')
map({ 'i', 't', 'c' }, '<C-a>', '<Home>')
map({ 'i', 't', 'c' }, '<C-e>', '<End>')
map({ 'i', 't', 'c' }, '<C-d>', '<Delete>')

-- К первому не пробельному символу
map('n', 'gh', 'g^')
map('x', 'gh', 'g^')
-- К последнему символу
map('n', 'gl', 'g_')
map('x', 'gl', 'g_')

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
map('n', '<leader>r', '<C-w>x')

-- К следующему буферу
map('n', '<leader><Tab>', ':bn<CR>')
-- К предыдущему буферу
map('n', '<leader><S-Tab>', ':bp<CR>')

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
map('n', '<leader>d', ':copy.<CR>')
map('x', '<leader>d', ':copy.-1<CR>gv')

-- Макросы
map('n', 'Q', 'q')
map('n', 'gQ', '@q')

-- Показать/скрыть сообщения диагностики в signcolumn
map('n', '<leader>td', toggle_diagnostics)

-- Открыть файл настроек
map('n', '<leader>cn', ':vert e ~/.config/nvim/init.lua<CR>')

-- Заменить значение слова на противоположное
map('n', '<leader>i', require('modules.toggler').toggle_cword_at_cursor)

map('n', '<C-->', ':vertical resize -2<CR>')
map('n', '<C-=>', ':vertical resize +2<CR>')

map('n', '<localleader>e', ':NeoTreeFocusToggle <CR>')
