-- Install magick: luarocks --local --lua-version=5.1 install magick
return {
  "3rd/image.nvim",
  enabled = function()
    local uv = vim.fn.has("nvim-0.10") == 1 and vim.uv or vim.loop
    local is_exist = uv.fs_stat(vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/magick/init.lua") ~= nil

    local function info(reason)
      vim.notify(
        ('Dependency of `3rd/image.nvim` luarock `magick` problem: "%s".\nPlugin will not be load.'):format(reason),
        vim.log.levels.INFO,
        { title = "Image.nvim" }
      )
    end

    if not is_exist then
      info("not found at $HOME/.luarocks/share/lua/5.1/magick/init.lua")
    else
      package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
      package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"

      local ok, msg = pcall(require, "magick")
      if not ok then
        -- Check this issue: https://github.com/3rd/image.nvim/issues/18?ysclid=lqf4h2y9hh666904664#issuecomment-1774962882
        is_exist = false
        info(msg)
      end
    end
    return is_exist
  end,
  event = "VeryLazy",
  config = function()
    require("image").setup({
      backend = "kitty",
      -- integrations = { markdown = { enabled = false } },
      integrations = {},
      max_width = 100,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    })

    local function has_image(id)
      local images = require("image").get_images()
      for _, image in ipairs(images) do
        if image.id == id then
          return true, image
        end
      end
      return false, nil
    end

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.png,*.jpg,*.jpeg,*.gif,*.webp,*.pdf",
      callback = function(event)
        local ok, api = pcall(require, "image")
        if not ok then
          return
        end

        local has, img = has_image(event.file)
        if has and img then
          vim.schedule(function()
            img:render()
          end)
          return
        end

        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_win_set_buf(win, buf)
        vim.cmd("bw " .. event.buf)
        vim.api.nvim_buf_set_name(buf, event.file)

        local image = api.from_file(event.file, { id = event.file, buffer = buf, window = win })
        if not image then
          return
        end
        vim.schedule(function()
          image:render()
        end)

        vim.api.nvim_create_autocmd({ "BufHidden", "BufDelete", "BufUnload", "WinClosed" }, {
          buffer = buf,
          callback = function()
            image:clear()
          end,
        })
      end,
    })
  end,
}
