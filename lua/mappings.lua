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
vim.g.maplocalleader = ','

-- Перемещение по визуальным строкам как по логическим
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- jk как <Esc>
map('i', PREF.common.escape_keys, '<Esc>')

-- закрыть nvim
map('n', '<Leader>q', '<Cmd>qa<Cr>')

-- терминальные клавиши (для использования в режиме INSERT)
map({ 'i', 't' }, '<C-f>', '<Right>')
map({ 'i', 't' }, '<C-b>', '<Left>')
map({ 'i', 't' }, '<C-.>', '<S-Right>')
map({ 'i', 't' }, '<C-,>', '<S-Left>')
map({ 'i', 't' }, '<C-p>', '<Up>')
map({ 'i', 't' }, '<C-n>', '<Down>')
map({ 'i', 't' }, '<C-a>', '<Home>')
map({ 'i', 't' }, '<C-e>', '<End>')
map({ 'i', 't' }, '<C-d>', '<Delete>')

-- К первому не пробельному символу
map('n', 'gh', 'g^')
map('x', 'gh', 'g^')
-- К последнему символу
map('n', 'gl', 'g_')
map('x', 'gl', 'g_')

-- Закрытие окна
map('n', 'q', '<Cmd>close<Cr>')

-- Открыть файл под курсором vsplit
map('n', 'sg', '<Cmd>vertical wincmd f<Cr>')

-- Передвижение по окнам
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Поменять окна местами
map('n', '<Leader>r', '<C-w>x')

-- К следующему буферу
map('n', '<Leader><Tab>', '<Cmd>bn<Cr>')
-- К предыдущему буферу
map('n', '<Leader><S-Tab>', '<Cmd>bp<Cr>')

-- Не копировать при удалении
-- map('n', 'x', '"_x')
-- map('x', 'x', '"_x')

-- Поменять слово со словом справа местами
map('n', '<Leader>s', 'dawea <Esc>px')

-- Замена текста без копирования в клипборд
map('x', 'p', '"_c<Esc>p')

-- К парной скобке
-- map('n', '<Bs>', '%')

-- Новая строка под курсором в любой позиции в режиме ввода
map('i', '<S-Cr>', '<C-o>o')

-- Добавить/убрать табуляцию
map('x', '<', '<gv')
map('x', '>', '>gv|')
map('x', '<S-Tab>', '<gv')
map('x', '<Tab>', '>gv|')

-- Сохранить изменения
map('n', '<C-s>', '<Esc><Cmd>up<Cr>')
map('i', '<C-s>', '<Esc><Cmd>up<Cr>')
map('v', '<C-s>', '<Esc><Cmd>up<Cr>')
map('x', '<C-s>', '<Esc><Cmd>up<Cr>')

-- Перемещение строк вверх/вниз
map('n', '<C-n>', '<Cmd>move+1<Cr>==')
map('n', '<C-p>', '<Cmd>move-2<Cr>==')
-- ВАЖНО: использовать : вместо <Cmd>
map('x', '<C-n>', ":move'>+<Cr>gv=gv")
map('x', '<C-p>', ":move'<-2<Cr>gv=gv")

-- Дублировать строку под курсором
map('n', '<Leader>d', '<Cmd>copy.<Cr>')
-- ВАЖНО: использовать : вместо <Cmd>
map('x', '<Leader>d', ':copy.-1<Cr>gv')

-- Макросы
map('n', 'Q', 'q')
map('n', 'gQ', '@q')

-- Показать/скрыть сообщения диагностики в signcolumn
map('n', '<Leader>td', toggle_diagnostics)

-- Открыть файл настроек
map('n', '<Leader>cn', '<Cmd>vert e ~/.config/nvim/init.lua<Cr>')

-- Заменить значение слова на противоположное
map('n', '<Leader>i', require('modules.toggler').toggle_cword_at_cursor)

map('n', '<C-->', '<Cmd>vertical resize -2<Cr>')
map('n', '<C-=>', '<Cmd>vertical resize +2<Cr>')

map('n', '<Localleader>e', '<Cmd>Neotree focus toggle <Cr>')

map('n', 'tsp', function()
  vim.treesitter.show_tree({ command = 'botright 60vnew' })
end)
