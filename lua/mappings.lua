local function map(mode, new_keys, to_do, options)
  local keymap = vim.keymap.set
  local default_options = {
    noremap = true,
    silent = true,
    expr = false,
  }
  if options then
    default_options = vim.tbl_extend('force', default_options, options)
  end
  local ok, error = pcall(keymap, mode, new_keys, to_do, default_options)
  if not ok then
    vim.notify(error, vim.log.levels.ERROR, {
      title = 'keymap',
    })
  end
end

local function toggle_diagnostics()
  local state = USER_SETTINGS.lsp.show_diagnostic
  USER_SETTINGS.lsp.show_diagnostic = not state
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

-- К первому не пробельному символу
map('n', 'H', '^')
map('v', 'H', '^')
map('x', 'H', '^')
-- К последнему символу
map('n', 'L', '$')
map('v', 'L', '$')
map('x', 'L', '$')

-- Закрытие окна
map('n', 'q', ':bdelete<CR>')

-- Передвижение по окнам
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- К следующему буферу
map('n', '<Tab>', ':bn<CR>')
-- К предыдущему буферу
map('n', '<S-Tab>', ':bp<CR>')

-- Не копировать одиночный символ при удалении
map('n', 'x', '"_x')
map('x', 'x', '"_x')

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

-- Фолдинг
map('n', '<CR>', 'za')

map('n', '<leader>q', toggle_diagnostics)

-- ========= Привязки для плагинов
-- SplitJoin
map('n', '<leader>j', ':SplitjoinJoin<CR>')
map('n', '<leader>s', ':SplitjoinSplit<CR>')

-- NvimTree, Neotree
local nvimtree_ok, _ = pcall(require, 'nvim-tree')
local neotree_ok, _ = pcall(require, 'neo-tree')
if nvimtree_ok then
  map('n', '<localleader>e', ':NvimTreeToggle <CR>')
elseif neotree_ok then
  map('n', '<localleader>e', ':NeoTreeFocusToggle <CR>')
else
  map('n', '<localleader>e', ':Lex 20<CR>')
end

-- ufo
-- local ufo_ok, ufo = pcall(require, 'ufo')
-- if ufo_ok then
--   map('n', 'zR', ufo.openAllFolds)
--   map('n', 'zM', ufo.closeAllFolds)
-- end

-- Telescope
local telescope_ok, telescope = pcall(require, 'telescope.builtin')
if telescope_ok then
  map('n', '<localleader>f', ':Telescope find_files<CR>')
  map('n', '<localleader>g', ':Telescope live_grep<CR>')
  map('n', '<localleader>d', ':Telescope diagnostics<CR>')
  map('n', '<localleader>o', ':Telescope oldfiles<CR>')
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
