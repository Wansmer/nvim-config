vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight copied text",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Rid auto comment for new string",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

if PREF.lsp.format_on_save then
  vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "Format on save",
    callback = function(e)
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ bufnr = e.buf, lsp_fallback = true })
      else
        local client = vim.lsp.get_clients({ bufnr = 0 })[1]
        if client then
          vim.lsp.buf.format()
        end
      end
    end,
  })
end

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Jump to the last place you’ve visited in a file before exiting",
  callback = function()
    local ignore_ft = { "neo-tree", "toggleterm", "lazy" }
    local ft = vim.bo.filetype
    if not vim.tbl_contains(ignore_ft, ft) then
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    pcall(require, "modules.key_listener")
    pcall(require, "modules.mode_nr")
    pcall(require, "modules.thincc")
    pcall(require, "usercmd")
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  desc = "Set colorcolumn equals textwidth",
  callback = function(data)
    local tw = vim.bo[data.buf].textwidth
    vim.opt_local.colorcolumn = tostring(tw)
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  desc = "Open :help with vertical split",
  pattern = { "*.txt" },
  callback = function()
    if vim.bo.filetype == "help" then
      vim.cmd.wincmd("L")
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Translate global keybindings",
  callback = function()
    local ok, lm = pcall(require, "langmapper")
    if ok then
      lm.automapping({ buffer = false })
    end
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  desc = "Redraw buffer when associated file is changed",
  command = "checktime",
})

-- Autoenable when 'relativenumber' is set to true. Need to restart neovim
if vim.opt.relativenumber:get() then
  local group = vim.api.nvim_create_augroup("toggle_relnum", { clear = false })
  local function set_relnum_back(win)
    vim.api.nvim_create_autocmd("CmdlineLeave", {
      group = group,
      once = true,
      callback = function()
        vim.wo[win].relativenumber = true
      end,
    })
  end

  vim.api.nvim_create_autocmd("CmdlineEnter", {
    desc = "Disables `relativenumber` when entering command line mode and enables it again when leaving",
    group = group,
    callback = function()
      local win = vim.api.nvim_get_current_win()
      if vim.wo[win].relativenumber then
        vim.wo[win].relativenumber = false
        vim.cmd("redraw")
        set_relnum_back(win)
      end
    end,
  })
end

vim.api.nvim_create_autocmd("BufHidden", {
  desc = "Delete [No Name] buffers",
  callback = function(data)
    if data.file == "" and vim.bo[data.buf].buftype == "" and not vim.bo[data.buf].modified then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, data.buf, {})
      end)
    end
  end,
})
