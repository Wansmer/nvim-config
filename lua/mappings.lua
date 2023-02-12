local map = require('utils').map()

local function toggle_diagnostics()
  local state = PREF.lsp.show_diagnostic
  PREF.lsp.show_diagnostic = not state
  if state then
    vim.diagnostic.disable()
    return
  end
  vim.diagnostic.enable()
end

-- Перемещение по визуальным строкам как по логическим
map('n', 'j', 'gj', { desc = 'Move cursor down (display and real line)' })
map('n', 'k', 'gk', { desc = 'Move cursor up (display and real line)' })

-- jk как <Esc>
vim.keymap.set('i', PREF.common.escape_keys, '<Esc>', { desc = 'Leave INSERT mode' })

-- закрыть nvim
map('n', '<Leader>q', '<Cmd>qa<Cr>', { desc = 'Close neovim' })

-- терминальные клавиши (для использования в режиме INSERT)
map({ 'i', 't' }, '<C-f>', '<Right>', { desc = 'Move cursor right one letter' })
map({ 'i', 't' }, '<C-b>', '<Left>', { desc = 'Move cursor left one letter' })
map({ 'i', 't' }, '<C-.>', '<S-Right>', { desc = 'Move cursor right on word' })
map({ 'i', 't' }, '<C-,>', '<S-Left>', { desc = 'Move cursor left on word' })
map({ 'i', 't' }, '<C-p>', '<Up>', { desc = 'Move cursor up one line' })
map({ 'i', 't' }, '<C-n>', '<Down>', { desc = 'Move cursor down one line' })
map({ 'i', 't' }, '<C-a>', '<Home>', { desc = 'Move cursor to start of the line' })
map({ 'i', 't' }, '<C-e>', '<End>', { desc = 'Move cursor to end of the line' })
map({ 'i', 't' }, '<C-d>', '<Delete>', { desc = 'Delete one letter after cursor' })
map('t', '<esc>', [[<C-\><C-n>]], { desc = 'Leave INSERT mode in terminal' })
map('t', 'jk', [[<C-\><C-n>]], { desc = 'Leave INSERT mode in terminal' })

-- К первому не пробельному символу
map('n', 'gh', 'g^', { desc = 'Go to first non-blank character in the line' })
map('x', 'gh', 'g^', { desc = 'Go to first non-blank character in the line' })
-- К последнему символу
map('n', 'gl', 'g_', { desc = 'Go to last non-blank character in the line' })
map('x', 'gl', 'g_', { desc = 'Go to last non-blank character in the line' })

-- Закрытие окна
map('n', 'q', '<Cmd>close<Cr>', { desc = 'Close current window' })

-- Передвижение по окнам
map('n', '<C-h>', '<C-w>h', { desc = 'Focus to left-side window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Focus to right-side window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Focus to top-side window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Focus to bottom-side window' })

-- Поменять окна местами
map('n', '<Leader>r', '<C-w>x', { desc = 'Swap windows with each other' })

-- К следующему буферу
map('n', '<Leader><Tab>', '<Cmd>bn<Cr>', { desc = 'Go to next buffer' })
-- К предыдущему буферу
map('n', '<Leader><S-Tab>', '<Cmd>bp<Cr>', { desc = 'Go to prev buffer' })

-- Не копировать при удалении
-- map('n', 'x', '"_x', { desc = '' })
-- map('x', 'x', '"_x', { desc = '' })

-- Поменять слово со словом справа местами
map('n', '<Leader>s', 'dawea <Esc>px', { desc = 'Swap word with right-side word' })

-- Замена текста без копирования в клипборд
map('x', 'p', '"_c<Esc>p', { desc = 'Paste without copying into register' })
-- Копирование текста с заменой разрыва строк на пробелы
map('x', '<C-y>', function()
  vim.cmd.normal('"+y')
  vim.fn.setreg('+', string.gsub(vim.fn.getreg('+'), '\n', ' '))
end, { desc = 'Copy and replace linebreak' })

-- К парной скобке
-- map('n', '<Bs>', '%', { desc = '' })

-- Новая строка под курсором в любой позиции в режиме ввода
map('i', '<S-Cr>', '<C-o>o', { desc = 'Create new line below and jump there' })

-- Добавить/убрать табуляцию
map('x', '<', '<gv', { desc = 'One indent left and reselect' })
map('x', '>', '>gv|', { desc = 'One indent right and reselect' })
map('x', '<S-Tab>', '<gv', { desc = 'One indent left and reselect' })
map('x', '<Tab>', '>gv|', { desc = 'One indent right and reselect' })

-- Сохранить изменения
map('n', '<C-s>', '<Esc><Cmd>up<Cr>', { desc = 'Save buffer into file' })
map('i', '<C-s>', '<Esc><Cmd>up<Cr>', { desc = 'Save buffer into file' })
map('v', '<C-s>', '<Esc><Cmd>up<Cr>', { desc = 'Save buffer into file' })
map('x', '<C-s>', '<Esc><Cmd>up<Cr>', { desc = 'Save buffer into file' })

-- Перемещение строк вверх/вниз
map('n', '<C-n>', '<Cmd>move+1<Cr>==', { desc = 'Move current line downward' })
map('n', '<C-p>', '<Cmd>move-2<Cr>==', { desc = 'Move current line upward' })
-- ВАЖНО: использовать : вместо <Cmd>
map('x', '<C-n>', ":move'>+<Cr>gv=gv", { desc = 'Move current selection downward and reselect' })
map('x', '<C-p>', ":move'<-2<Cr>gv=gv", { desc = 'Move current selection upward and reselect' })

-- Дублировать строку под курсором
map('n', '<Leader>d', '<Cmd>copy.<Cr>', { desc = 'Duplicate current line' })
-- ВАЖНО: использовать : вместо <Cmd>
map('x', '<Leader>d', ':copy.-1<Cr>gv', { desc = 'Duplicate current selection and reselect' })

-- Макросы
map('n', 'Q', 'q', { desc = 'Start recording macro' })
-- map('n', 'gQ', '@q', { desc = '' })

-- Показать/скрыть сообщения диагностики в signcolumn
map('n', '<Leader>td', toggle_diagnostics, { desc = 'Toggle diagnostic' })

-- Открыть файл настроек
map('n', '<Leader>cn', '<Cmd>vert e ~/.config/nvim/init.lua<Cr>', { desc = 'Open init.lua' })

-- Заменить значение слова на противоположное
map(
  'n',
  '<Leader>i',
  require('modules.toggler').toggle_cword_at_cursor,
  { desc = 'Module Toggler: toggle word under cursor' }
)

map('n', '<C-->', '<Cmd>vertical resize -2<Cr>', { desc = 'Vertical resize +' })
map('n', '<C-=>', '<Cmd>vertical resize +2<Cr>', { desc = 'Vertical resize -' })

map('n', '<Localleader>e', '<Cmd>Neotree focus toggle <Cr>', { desc = 'Open file explorer' })

map('n', 'tsp', function()
  vim.treesitter.show_tree({ command = 'botright 60vnew' })
end, { desc = 'Open treesitter tree for current buffer' })

-- Gitsigns
map('n', '<Leader>gp', ':Gitsigns prev_hunk<CR>', { desc = 'Plug Gitsigns: jump to prev hunk' })
map('n', '<Leader>gn', ':Gitsigns next_hunk<CR>', { desc = 'Plug Gitsigns: jump to next hunk' })
map('n', '<Leader>gs', ':Gitsigns preview_hunk<CR>', { desc = 'Plug Gitsigns: preview hunk' })
map('n', '<Leader>gd', ':Gitsigns diffthis<CR>', { desc = 'Plug Gitsigns: open diffmode' })
map('n', '<Leader>ga', ':Gitsigns stage_hunk<CR>', { desc = 'Plug Gitsigns: stage current hunk' })
map('n', '<Leader>gr', ':Gitsigns reset_hunk<CR>', { desc = 'Plug Gitsigns: reset current hunk' })
map('n', '<Leader>gA', ':Gitsigns stage_buffer<CR>', { desc = 'Plug Gitsigns: stage current buffer' })
map('n', '<Leader>gR', ':Gitsigns reset_buffer<CR>', { desc = 'Plug Gitsigns: reset current buffer' })

-- Telescope
map('n', '<localleader>f', require('telescope.builtin').find_files, { desc = '' })
map('n', '<localleader>g', require('telescope.builtin').live_grep, { desc = '' })
map('n', '<localleader>b', require('telescope.builtin').buffers, { desc = '' })
map('n', '<localleader>d', ':Telescope diagnostics<CR>', { desc = '' })
map('n', '<localleader>o', require('telescope.builtin').oldfiles, { desc = '' })
map('n', '<localleader>n', ':Telescope notify<CR>', { desc = '' })
map('n', '<localleader><localleader>', require('telescope.builtin').current_buffer_fuzzy_find, { desc = '' })
map('n', '<localleader>s', function()
  require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cword>') })
end, { desc = '' })
map('n', '<localleader>p', function()
  require('telescope.builtin').find_files({
    default_text = vim.fn.expand('<cword>'),
  })
end, { desc = '' })

-- For using with langmapper
-- Mini.surround
map('n', 'sa', 'sa', { remap = true })
map('n', 'sd', 'sd', { remap = true })
map('n', 'sc', 'sc', { remap = true })
map('x', 'sa', 'sa', { remap = true })

-- Comment.nvim
map('n', 'gcc', function()
  return vim.v.count == 0 and '<Plug>(comment_toggle_linewise_current)' or '<Plug>(comment_toggle_linewise_count)'
end, { expr = true })

map('n', 'gbc', function()
  return vim.v.count == 0 and '<Plug>(comment_toggle_blockwise_current)' or '<Plug>(comment_toggle_blockwise_count)'
end, { expr = true })

map('x', 'gc', '<Plug>(comment_toggle_linewise_visual)')
map('x', 'gb', '<Plug>(comment_toggle_blockwise_visual)')

-- Notify
map('n', '<leader>a', ':Notifications<CR>')

-- Ufo
map('n', 'zR', require('ufo').openAllFolds)
map('n', 'zM', require('ufo').closeAllFolds)

-- ZenMode
map('n', 'Z', '<Cmd>ZenMode<Cr>')
