-- Install magick: luarocks --local --lua-version=5.1 install magick
return {
  '3rd/image.nvim',
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
    })
  end,
  lazy = false,
}
