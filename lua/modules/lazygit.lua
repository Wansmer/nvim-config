local ok, t = pcall(require, "toggleterm.terminal")

if not ok then
  return
end

local function size(max, value)
  return value > 1 and math.min(value, max) or math.floor(max * value)
end

local width = size(vim.opt.columns:get(), 0.8)
local height = size(vim.opt.lines:get(), 0.8)
local col = math.floor((vim.opt.columns:get() - width) / 2)
local row = math.floor((vim.opt.lines:get() - height) / 2)

local lazygit = t.Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    relative = "editor",
    border = "double",
    style = "minimal",
    col = col,
    row = row,
    width = width,
    height = height,
  },
  on_open = function(term)
    vim.keymap.set("t", "q", "<Cmd>close<Cr>", { buffer = term.bufnr })
    vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = term.bufnr })
  end,
})

vim.keymap.set("n", "<C-'>", function()
  lazygit:toggle()
end)
