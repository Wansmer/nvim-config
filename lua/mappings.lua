local u = require('utils')
local cb = u.lazy_rhs_cb
local map = vim.keymap.set
local del = vim.keymap.del

-- ============================================================================
-- Escape mappings
-- ============================================================================
for _, keys in ipairs(PREF.common.escape_keys) do
  map('t', keys, [[<C-\><C-n>]], { desc = 'Leave INSERT mode in terminal' })
  map('i', keys, '<Esc>', { desc = 'Leave INSERT mode' })
end
map('t', '<esc>', [[<C-\><C-n>]], { desc = 'Leave INSERT mode in terminal' })

-- ============================================================================
-- Manage Neovim, buffers and windows
-- ============================================================================
map('n', '<Leader>q', '<Cmd>qa<Cr>', { desc = 'Close neovim' })
map('x', '<Leader>q', '<Esc><Cmd>qa<Cr>', { desc = 'Close neovim' })
map('n', 'q', '<Cmd>close<Cr>', { desc = 'Close current window' })
map('n', '<Leader>r', '<C-w>x', { desc = 'Swap windows with each other' })
map('n', '<Tab>', '<Cmd>bn<Cr>', { desc = 'Go to next buffer' })
map('n', '<S-Tab>', '<Cmd>bp<Cr>', { desc = 'Go to prev buffer' })
map('n', '<C-h>', '<C-w>h', { desc = 'Focus to left-side window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Focus to right-side window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Focus to top-side window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Focus to bottom-side window' })
map({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>up<Cr>', { desc = 'Save buffer into file' })
map('n', '<C-->', '<Cmd>vertical resize -2<Cr>', { desc = 'Vertical resize +' })
map('n', '<C-=>', '<Cmd>vertical resize +2<Cr>', { desc = 'Vertical resize -' })

-- ============================================================================
-- Movements on text
-- ============================================================================
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", {
  expr = true,
  desc = 'Move cursor down (display and real line)',
})
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", {
  expr = true,
  desc = 'Move cursor up (display and real line)',
})
map({ 'i', 't' }, '<C-f>', '<Right>', { desc = 'Move cursor right one letter' })
map({ 'i', 't', 'c' }, '<C-b>', '<Left>', { desc = 'Move cursor left one letter' })
map({ 'i', 't', 'c' }, '<C-.>', '<S-Right>', { desc = 'Move cursor right on word' })
map({ 'i', 't', 'c' }, '<C-,>', '<S-Left>', { desc = 'Move cursor left on word' })
map({ 'i', 't' }, '<C-p>', '<Up>', { desc = 'Move cursor up one line' })
map({ 'i', 't' }, '<C-n>', '<Down>', { desc = 'Move cursor down one line' })
map({ 'i', 't' }, '<C-a>', '<Home>', { desc = 'Move cursor to start of the line' })
map({ 'i', 't' }, '<C-e>', '<End>', { desc = 'Move cursor to end of the line' })
map({ 'i', 't' }, '<C-d>', '<Delete>', { desc = 'Delete one letter after cursor' })
map({ 'i' }, '<C-k>', '<Esc>C', { desc = 'Delete one letter after cursor' })
map({ 'n', 'x' }, '*', '*N', { desc = 'Search word or selection' })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ 'n', 'x', 'o' }, 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map({ 'n', 'x', 'o' }, 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- ============================================================================
-- Text edit
-- ============================================================================
-- WARNING: use ':' instead <Cmd> in visual mode (x, s, v) + ex command
map('n', '<Leader>s', 'dawea <Esc>px', { desc = 'Swap word with right-side word' })
map('i', '<S-Cr>', '<C-o>o', { desc = 'Create new line below and jump there' })
map('x', '<', '<gv', { desc = 'One indent left and reselect' })
map('x', '>', '>gv|', { desc = 'One indent right and reselect' })
map('x', '<S-Tab>', '<gv', { desc = 'One indent left and reselect' })
map('x', '<Tab>', '>gv|', { desc = 'One indent right and reselect' })
map('n', '<C-n>', '<Cmd>move+1<Cr>==', { desc = 'Move current line downward' })
map('n', '<C-p>', '<Cmd>move-2<Cr>==', { desc = 'Move current line upward' })
map('x', '<C-n>', ":move'>+<Cr>gv=gv", { desc = 'Move current selection downward and reselect' })
map('x', '<C-p>', ":move'<-2<Cr>gv=gv", { desc = 'Move current selection upward and reselect' })
map('n', '<Leader>d', '<Cmd>copy.<Cr>', { desc = 'Duplicate current line' })
map('x', '<Leader>d', ':copy.-1<Cr>gv', { desc = 'Duplicate current selection and reselect' })
map('x', 'p', '"_c<Esc>p', { desc = 'Paste without copying into register' })
map('n', '<Leader>i', cb('modules.toggler', 'toggle_word'), { desc = 'Module Toggler: toggle word under cursor' })
map('v', 'sa', cb('modules.surround', 'add_visual'))
map('n', 'sa', cb('modules.surround', 'add'))
map('n', 'sr', cb('modules.surround', 'remove'))
map('n', 'sc', cb('modules.surround', 'replace'))

-- ============================================================================
-- Other
-- ============================================================================
map('n', 'Q', 'q', { desc = 'Start recording macro' })
map('n', '[q', '<Cmd>cnext<Cr>', { desc = 'Go to next match in quickfix list' })
map('n', ']q', '<Cmd>cprev<Cr>', { desc = 'Go to next match in quickfix list' })
map('n', '<Leader><Leader>', function()
  local plugins = require('lazy.core.config').plugins
  for name, plug in pairs(plugins) do
    if plug.dev then
      -- See: https://github.com/folke/lazy.nvim/issues/445#issuecomment-1426070401
      local to_reload = plugins[name]
      require('lazy.core.loader').reload(to_reload)

      local loaders = vim.loader.find(name, { all = true })
      for _, loader in ipairs(loaders) do
        vim.loader.reset(loader.modpath)
      end

      vim.notify('Reload ' .. name)
    end
  end
end, { desc = 'Reload all dev plugins' })
map('n', 'S', '"_S', { desc = "'S' without copying to clipboard" })
map('n', 'C', '"_C', { desc = "'C' without copying to clipboard" })
map('n', 'D', '"_D', { desc = "'D' without copying to clipboard" })

del('n', 'Y')
