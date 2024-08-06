local u = require("utils")
local cb = u.lazy_rhs_cb
local map = vim.keymap.set
local del = vim.keymap.del

-- ============================================================================
-- Escape mappings
-- ============================================================================
map("t", "<esc>", [[<C-\><C-n>]], { desc = "Leave INSERT mode in terminal" })

-- ============================================================================
-- Manage Neovim, buffers and windows
-- ============================================================================
map("n", "<Leader>q", "<Cmd>qa<Cr>", { desc = "Close neovim" })
map("x", "<Leader>q", "<Esc><Cmd>qa<Cr>", { desc = "Close neovim" })
map("n", "q", "<Cmd>close<Cr>", { desc = "Close current window" })
map("n", "<Leader>r", "<C-w>x", { desc = "Swap windows with each other" })
map("n", "<Tab>", "<Cmd>bn<Cr>", { desc = "Go to next buffer" })
map("n", "<S-Tab>", "<Cmd>bp<Cr>", { desc = "Go to prev buffer" })
map("n", "<C-h>", "<C-w>h", { desc = "Focus to left-side window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus to right-side window" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus to top-side window" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus to bottom-side window" })
map({ "n", "i", "x" }, "<D-s>", "<Esc><Cmd>up<Cr>", { desc = "Save buffer into file" })
map({ "n", "i", "x" }, "<C-s>", "<Esc><Cmd>up<Cr>", { desc = "Save buffer into file" })
map("n", "<C-->", "<Cmd>vertical resize -2<Cr>", { desc = "Vertical resize +" })
map("n", "<C-_>", "<Cmd>vertical resize -2<Cr>", { desc = "Vertical resize +" }) -- For wezterm, because it doesn't support <C--> and sent <C-_>
map("n", "<C-=>", "<Cmd>vertical resize +2<Cr>", { desc = "Vertical resize -" })

-- ============================================================================
-- Movements on text
-- ============================================================================
map("n", "j", "v:count == 0 ? 'gj' : 'j'", {
  expr = true,
  desc = "Move cursor down (display and real line)",
})
map("n", "k", "v:count == 0 ? 'gk' : 'k'", {
  expr = true,
  desc = "Move cursor up (display and real line)",
})
map({ "i", "t" }, "<C-f>", "<Right>", { desc = "Move cursor right one letter" })
map({ "i", "t", "c" }, "<C-b>", "<Left>", { desc = "Move cursor left one letter" })
map({ "i", "t", "c" }, "<M-f>", "<S-Right>", { desc = "Move cursor right on word" })
map({ "i", "t", "c" }, "<M-b>", "<S-Left>", { desc = "Move cursor left on word" })
map({ "i", "t" }, "<C-p>", "<Up>", { desc = "Move cursor up one line" })
map({ "i", "t" }, "<C-n>", "<Down>", { desc = "Move cursor down one line" })
map({ "i", "t" }, "<C-a>", "<Home>", { desc = "Move cursor to start of the line" })
map({ "i", "t" }, "<C-e>", "<End>", { desc = "Move cursor to end of the line" })
map({ "i" }, "<C-d>", "<Delete>", { desc = "Delete one letter after cursor" })
map({ "i" }, "<C-k>", "<Esc>C", { desc = "Delete one letter after cursor" })
map({ "n", "x" }, "*", "*N", { desc = "Search word or selection" })
map({ "i" }, "<M-a>", "<C-o>{", { desc = "Move to the beginning of the current paragraph" })
map({ "i" }, "<M-e>", "<C-o>}", { desc = "Move to the end of the current paragraph" })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- ============================================================================
-- Text edit
-- ============================================================================
-- WARNING: use ':' instead <Cmd> in visual mode (x, s, v) + ex command
local function duplicate_line()
  local times = vim.v.count == 0 and 1 or vim.v.count
  for _ = 1, times, 1 do
    vim.cmd.copy(".")
  end
end

local function duplicate_selection()
  local restore_autocmd = u.disable_autocmd("toggle_relnum")

  local times = vim.v.count == 0 and 1 or vim.v.count
  for _ = 1, times, 1 do
    vim.api.nvim_feedkeys(vim.keycode(":copy.-1<Cr>gv"), "n", true)
  end

  restore_autocmd()
end

local function move_line(op)
  return function()
    local start = op == "+" and 1 or 2
    local count = vim.v.count
    local times = count == 0 and start or (op == "+" and count or count + 1)
    local ok, _ = pcall(vim.cmd.move, op .. times)
    if ok then
      vim.cmd.norm("==")
    end
  end
end

local function move_selected(op)
  return function()
    local restore_autocmd = u.disable_autocmd("toggle_relnum")

    -- ":move'>+<Cr>gv=gv"
    -- ":move'<-2<Cr>gv=gv"
    local start = op == "+" and "" or 2
    local count = vim.v.count
    local times = count == 0 and start or (op == "+" and count or count + 1)
    local mark = op == "+" and "'>" or "'<"
    vim.api.nvim_feedkeys(vim.keycode(":move" .. mark .. op .. times .. "<Cr>gv=gv"), "n", true)

    restore_autocmd()
  end
end

map("n", "<Leader>d", duplicate_line, { desc = "Duplicate current line" })
map("x", "<Leader>d", duplicate_selection, { desc = "Duplicate current selection and reselect" })
map("n", "<C-n>", move_line("+"), { desc = "Move current line downward" })
map("n", "<C-p>", move_line("-"), { desc = "Move current line upward" })
map("x", "<C-n>", move_selected("+"), { desc = "Move current selection downward and reselect" })
map("x", "<C-p>", move_selected("-"), { desc = "Move current selection upward and reselect" })
-- map('n', '<Leader>s', 'dawea <Esc>px', { desc = 'Swap word with right-side word' })
map("i", "<S-Cr>", "<C-o>o", { desc = "Create new line below and jump there" })
map("x", "<", "<gv", { desc = "One indent left and reselect" })
map("x", ">", ">gv|", { desc = "One indent right and reselect" })
map("x", "<S-Tab>", "<gv", { desc = "One indent left and reselect" })
map("x", "<Tab>", ">gv|", { desc = "One indent right and reselect" })
map("x", "p", '"_c<Esc>p', { desc = "Paste without copying into register" })
map("n", "<Leader>i", cb("modules.toggler", "toggle_word"), { desc = "Module Toggler: toggle word under cursor" })
map("v", "sa", cb("modules.surround", "add_visual"))
map("n", "sa", cb("modules.surround", "add"))
map("n", "sr", cb("modules.surround", "remove"))
map("n", "sc", cb("modules.surround", "replace"))

-- ============================================================================
-- Other
-- ============================================================================
map("n", "Q", "q", { desc = "Start recording macro" })
map("n", "[q", "<Cmd>cnext<Cr>", { desc = "Go to next match in quickfix list" })
map("n", "]q", "<Cmd>cprev<Cr>", { desc = "Go to next match in quickfix list" })
map("n", "<Leader><Leader>", function()
  local plugins = require("lazy.core.config").plugins
  for name, plug in pairs(plugins) do
    if plug.dev then
      -- See: https://github.com/folke/lazy.nvim/issues/445#issuecomment-1426070401
      local to_reload = plugins[name]
      require("lazy.core.loader").reload(to_reload)

      local loaders = vim.loader.find(name, { all = true })
      for _, loader in ipairs(loaders) do
        vim.loader.reset(loader.modpath)
      end

      vim.notify("Reload " .. name)
    end
  end
end, { desc = "Reload all dev plugins" })
map("n", "S", '"_S', { desc = "'S' without copying to clipboard" })
map("n", "C", '"_C', { desc = "'C' without copying to clipboard" })
map("n", "D", '"_D', { desc = "'D' without copying to clipboard" })
map("x", "/", "<Esc>/\\%V", { desc = "Search in visual region" })
map("n", "<leader>ts", function()
  vim.opt.spell = not vim.opt.spell:get()
  local langs = vim.fn.join(vim.opt.spelllang:get(), ", ")
  vim.notify("Spell check for " .. langs .. ": " .. (vim.opt.spell:get() and "ON" or "OFF"))
end, { desc = "Toggle spell check" })

del("n", "Y")
