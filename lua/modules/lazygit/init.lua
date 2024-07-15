--[[
Attempt to use lazygit inside Neovim with file opening support.
Opening implemented like in yazi, nnn and ranger: store file(s) name in tmp file and read it when
file should be opened
]]

local ok, t = pcall(require, "toggleterm.terminal")

if not ok then
  return
end

local map = vim.keymap.set
local hl = vim.api.nvim_set_hl

local function size(max, value)
  return value > 1 and math.min(value, max) or math.floor(max * value)
end

local width = size(vim.opt.columns:get(), 0.8)
local height = size(vim.opt.lines:get(), 0.8)
local col = math.floor((vim.opt.columns:get() - width) / 2)
local row = math.floor((vim.opt.lines:get() - height) / 2)

local ns = vim.api.nvim_create_namespace("__parts.lazygit__")
local lg_config = vim.fs.joinpath(vim.fn.stdpath("config")--[[@as string]], "lua/modules/lazygit", "config.yml")
local tmp_path = vim.fs.joinpath(vim.fn.stdpath("config")--[[@as string]], "/lua/modules/lazygit/tmp")

local lazygit = t.Terminal:new({
  cmd = "lazygit -ucf " .. lg_config,
  dir = "git_dir",
  direction = "float",
  close_on_exit = true,
  float_opts = {
    relative = "editor",
    border = "double",
    style = "minimal",
    col = col,
    row = row,
    width = width,
    height = height,
  },
  on_exit = vim.schedule_wrap(function()
    local files_ok, files = pcall(vim.fn.readfile, tmp_path)
    if not files_ok then
      return
    end
    vim.fn.delete(tmp_path)
    -- File is now a single file, but in the future it can be an array.
    for _, file in ipairs(files) do
      vim.cmd.edit(file)
    end
  end),
  on_open = function(term)
    local norm = vim.api.nvim_get_hl(0, { name = "Normal" })
    local val = vim.tbl_deep_extend("force", norm, { bg = "#000000" })
    hl(ns, "NormalFloat", val)
    hl(ns, "FloatBorder", val)
    vim.api.nvim_win_set_hl_ns(term.window, ns)

    map("t", "<Esc>", "<Esc>", { buffer = term.bufnr })
    map("t", "o", function()
      vim.api.nvim_feedkeys(vim.keycode("G"), "n", true)
      vim.defer_fn(function() -- don't works with just `schedule`
        term:shutdown()
        term:close()
      end, 0)
    end, { buffer = term.bufnr })
  end,
})

vim.keymap.set({ "n", "i", "t" }, "<C-'>", function()
  lazygit:toggle()
end)
