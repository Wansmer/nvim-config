-- Install magick: luarocks --local --lua-version=5.1 install magick
return {
  '3rd/image.nvim',
  event = 'VeryLazy',
  enabled = function()
    local is_exist = vim.loop.fs_stat(vim.fn.expand('$HOME') .. '/.luarocks/share/lua/5.1/magick/init.lua')
    return is_exist ~= nil
  end,
  init = function()
    -- Example for configuring Neovim to load user-installed installed Lua rocks:
    package.path = package.path .. ';' .. vim.fn.expand('$HOME') .. '/.luarocks/share/lua/5.1/?/init.lua;'
    package.path = package.path .. ';' .. vim.fn.expand('$HOME') .. '/.luarocks/share/lua/5.1/?.lua;'
  end,
  config = function()
    require('image').setup({
      backend = 'kitty',
      max_height_window_percentage = 100,
      integrations = {
        markdown = {
          enabled = true,
        },
      },
    })

    local function has_image(id)
      local images = require('image').get_images()
      for _, image in ipairs(images) do
        if image.id == id then
          return true, image
        end
      end
      return false, nil
    end

    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = '*.png,*.jpg,*.jpeg,*.gif,*.webp',
      callback = function(event)
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_win_set_buf(win, buf)
        vim.cmd('bw ' .. event.buf)
        vim.api.nvim_buf_set_name(buf, event.file)

        local ok, api = pcall(require, 'image')
        if not ok then
          return
        end

        local image = api.from_file(event.file, {
          id = event.file,
          buffer = buf,
          window = win,
        })

        image:render()

        vim.api.nvim_create_autocmd({ 'BufHidden', 'BufDelete', 'BufUnload', 'WinClosed' }, {
          buffer = buf,
          callback = function(e)
            image:clear()
          end,
        })
      end,
    })
  end,
  lazy = false,
}
