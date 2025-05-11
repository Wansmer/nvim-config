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

if vim.g.vscode then
  -- It's the only way to get `g[jk]` to work in vscode
  vim.cmd([[
  nmap j gj
  nmap k gk
  vmap j gj
  vmap k gk
  nmap <Down> gj
  nmap <Up> gk
  vmap <Down> gj
  vmap <Up> gk
  ]])
end

map({ "c" }, "<C-f>", function()
  local c = vim.fn.getcmdpos()
  return vim.fn.getcmdline():sub(c, c) == "" and "<C-f>" or "<Right>"
end, { expr = true, desc = "Move cursor right one letter in cmd or open cmd window if next char is empty" })
map({ "i" }, "<C-f>", "<Right>", { desc = "Move cursor right one letter" })
map({ "i", "c" }, "<C-b>", "<Left>", { desc = "Move cursor left one letter" })
map({ "i", "c" }, "<M-f>", "<S-Right>", { desc = "Move cursor right on word" })
map({ "i", "c" }, "<M-b>", "<S-Left>", { desc = "Move cursor left on word" })
map({ "i", "t" }, "<C-p>", "<Up>", { desc = "Move cursor up one line" })
map({ "i", "t" }, "<C-n>", "<Down>", { desc = "Move cursor down one line" })
map({ "i", "t" }, "<C-a>", "<Home>", { desc = "Move cursor to start of the line" })
map({ "i", "t" }, "<C-e>", "<End>", { desc = "Move cursor to end of the line" })
map({ "i" }, "<C-d>", "<Delete>", { desc = "Delete one letter after cursor" })
map({ "i" }, "<C-k>", "<Esc>C", { desc = "Delete all after cursor" })
map({ "n", "x" }, "*", "*N", { desc = "Search word or selection" })
map({ "i" }, "<M-a>", "<C-o>{", { desc = "Move to the beginning of the current paragraph" })
map({ "i" }, "<M-e>", "<C-o>}", { desc = "Move to the end of the current paragraph" })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- Issue explanation: https://github.com/nvim-telescope/telescope.nvim/issues/1579#issuecomment-989767519
map({ "i", "t" }, "<C-w>", "<C-S-w>", { desc = "Unix default <C-w> behavior" })

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
map("v", "s", cb("modules.surround", "add_visual"))
map("n", "ys", cb("modules.surround", "add"))
map("n", "ds", cb("modules.surround", "remove"))
map("n", "cs", cb("modules.surround", "replace"))

-- Auto replace paired symbols with `r` command,
-- e.g. `(lalala)` with cursor on '(' and press `r[` will be replaced with `[lalala]`
--
-- TODO: make it greedy for ', ", `, e.g. `"la "la" la"` replaced with `[la "la" la]`, not `[la ] la" la"`
map("n", "r", function()
  local paired = require("modules.surround").paired
  local surround = require("modules.surround").surround

  local function trim_pair(pair)
    return unpack(vim
      .iter(pair)
      :map(function(s)
        return vim.trim(s)
      end)
      :totable())
  end

  vim.opt.guicursor:append("n-v-c-sm:hor26")
  pcall(function()
    local cur = vim.api.nvim_win_get_cursor(0)
    local replace_char = vim.fn.getcharstr()
    local r_pair = paired[replace_char]

    -- Get char under cursor (only 1-byte length for now)
    local cursor_char = vim.api.nvim_get_current_line():sub(cur[2] + 1, cur[2] + 1)
    local c_pair = paired[cursor_char]

    -- If the symbol under the cursor and the replacement symbol are both paired
    if c_pair and r_pair then
      local from, _ = trim_pair(c_pair)
      local to, _ = trim_pair(r_pair)

      surround.replace_surround(from, to)
      vim.api.nvim_win_set_cursor(0, cur)
      return
    end
    -- Default `r` behavior
    vim.api.nvim_feedkeys(vim.keycode("r" .. replace_char), "nix", false)
  end)

  -- Need to restore guicursor even if the function fails
  vim.opt.guicursor:remove("n-v-c-sm:hor26")
end)

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

map("n", "`", "'")
map("n", "'", "`")

map("n", "<A-l>", "3zl")
map("n", "<A-h>", "3zh")

map("i", "<C-j>", "<C-g>u<Esc>[s1z=`]a<C-g>u")

local function calc()
  local c = vim.api.nvim_win_get_cursor(0)
  local sr, sc, er, ec = c[1] - 1, c[2], c[1] - 1, c[2]
  local shift = 0
  local default = ""
  local mode = vim.fn.mode()

  if mode == "v" then
    sr, sc, er, ec = u.to_api_range(u.get_visual_range())
    default = vim.api.nvim_buf_get_text(0, sr, sc, er, ec, {})[1]
    shift = -1
  end

  vim.ui.input({ prompt = " 󱖦 Calc: ", default = default }, function(input)
    local res_cb, err = loadstring("return " .. input)
    if err then
      vim.notify(err, vim.log.levels.WARN, { title = "Lua based calc" })
      return
    end

    local result = tostring(res_cb())

    vim.api.nvim_buf_set_text(0, sr, sc, er, ec, { result })
    vim.api.nvim_win_set_cursor(0, { c[1], sc + #result + shift })
  end)
end

map({ "i", "t", "v" }, "<C-r><C-=>", calc, { desc = "Lua based calc" })

pcall(del, "n", "Y")

-- Disable default lsp mappings
pcall(del, "n", "grn")
pcall(del, "n", "gra")
pcall(del, "n", "grr")
pcall(del, "n", "gri")
-- pcall(del, "n", "g0")
