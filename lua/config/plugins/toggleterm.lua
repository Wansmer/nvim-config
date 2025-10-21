return {
  "akinsho/toggleterm.nvim",
  enabled = true,
  keys = { "<C-;>" },
  cmd = { "ToggleTerm", "ToggleTermToggleAll" },
  config = function()
    local toggleterm = require("toggleterm")

    local separator = vim.api.nvim_get_hl(0, { name = "VertSplit", link = false })
    vim.api.nvim_set_hl(0, "TTBorder", { bg = "#0a0a0a", fg = separator.fg })
    vim.api.nvim_set_hl(0, "TTNormal", { bg = "#0a0a0a" })

    toggleterm.setup({
      size = 23,
      open_mapping = [[<C-;>]],
      hide_numbers = true,
      shade_filetypes = {},
      start_in_insert = true,
      insert_mappings = true,
      persist_size = false,
      persist_mode = false,
      direction = "horizontal", -- 'float', 'horizontal', 'vertical', 'tab'
      close_on_exit = true,
      shell = vim.o.shell,
      -- highlights = {}, -- Not working
      float_opts = {
        border = { "", "", "", " ", " ", " ", " ", " " },
        relative = "editor",
        width = vim.opt.columns:get(),
        height = 23,
        col = 0,
        row = vim.opt.lines:get(),
        style = "minimal",
        title = "Hello KITTY",
        title_pos = "left",
        noautocmd = true,
      },
      on_open = function(term)
        vim.opt.winhighlight = "Normal:TTNormal,FloatBorder:TTBorder"
        local map = vim.keymap.set

        ---Resize the terminal
        ---@param mode boolean true is increase, false is decrease
        ---@param step number lines count to increase or decrease
        local function resize(mode, step)
          return function()
            local win_opts = vim.api.nvim_win_get_config(term.window)
            local cond = mode and (win_opts.height <= vim.opt.lines:get() - step) or (win_opts.height > step)
            if cond then
              win_opts.height = win_opts.height + (mode and step or (step * -1))
              vim.api.nvim_win_set_config(term.window, win_opts)
            end
          end
        end

        map({ "t", "i", "n" }, "<C-=>", resize(true, 5), { buffer = term.bufnr })
        map({ "t", "i", "n" }, "<C-->", resize(false, 5), { buffer = term.bufnr })
        map({ "t", "i", "n" }, "<C-_>", resize(false, 5), { buffer = term.bufnr }) -- For wezterm, because it doesn't support <C--> and sent <C-_>
        map({ "n" }, "gx", function()
          local path = vim.fn.expand("<cfile>")
          if path == "" then
            return
          end

          -- check if file exists
          if vim.uv.fs_stat(vim.fn.fnamemodify(path, ":p")) then
            local cursor = vim.api.nvim_win_get_cursor(0)
            local line = vim.api.nvim_buf_get_lines(term.bufnr, cursor[1] - 1, cursor[1], false)[1]
            local row_col = string.match(line, path .. ":(%d+:%d+)")

            -- open <cfile> in vsplit even if row_col is nil
            vim.cmd("vs " .. path)
            if row_col then
              row_col = vim.iter(vim.split(row_col, ":")):map(tonumber):totable()
              vim.api.nvim_win_set_cursor(0, row_col)
            end
            return
          end

          -- fallback to open <cfile> with the system default handler (default gx behavior)
          -- see: h vim.ui.open()
          local ok, msg = pcall(vim.ui.open, path)
          if not ok then
            vim.notify(msg --[[@as string]], vim.log.levels.ERROR)
          end
        end, { buffer = term.bufnr })
      end,
      on_close = vim.schedule_wrap(function()
        local ok, nt = pcall(require, "neo-tree.sources.manager")
        if ok then
          nt.refresh("filesystem")
        end
        vim.cmd.stopinsert()
      end),
    })
  end,
}
