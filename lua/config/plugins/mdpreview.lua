return {
  "iamcco/markdown-preview.nvim",
  enabled = true,
  build = "cd app && npm install && git restore .",
  ft = { "markdown" },
  config = function()
    local map = vim.keymap.set
    local TITLE = "md_preview"
    local cmd = "kitty @ launch --dont-take-focus --title " .. TITLE .. " --bias 45 awrit "

    local is_open = false
    -- Based on https://github.com/iamcco/markdown-preview.nvim/issues/363#issuecomment-2424574202
    vim.api.nvim_exec2(
      ([[
        function MkdpBrowserFn(url)
          execute "silent ! %s" . a:url
        endfunction
      ]]):format(cmd),
      {}
    )

    local function close_preview()
      vim.system({
        "kitty",
        "@",
        "close-window",
        "--match=title:" .. TITLE,
      })
    end

    local function open_preview()
      vim.cmd("MarkdownPreview")
    end

    local function toggle_preview()
      if is_open then
        close_preview()
        is_open = false
      else
        open_preview()
        is_open = true
      end
    end

    vim.g.mkdp_theme = "dark"
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_browserfunc = "MkdpBrowserFn"

    vim.api.nvim_create_autocmd({ "BufDelete", "VimLeavePre" }, {
      pattern = "*",
      callback = close_preview,
    })

    map("n", "<leader>p", toggle_preview, { silent = true })
    map("n", "<C-S-k>", function()
      vim
        .system({ "kitten", "@", "resize-window", "--match=id:" .. vim.fn.getenv("KITTY_WINDOW_ID"), "--increment=4" })
        :wait()
      vim.cmd.redraw()
    end)
    map("n", "<C-S-j>", function()
      vim.system({ "kitten", "@", "resize-window", "--match=id:" .. vim.env.KITTY_WINDOW_ID, "--increment=-4" }):wait()
      vim.cmd.redraw()
    end)
  end,
}
