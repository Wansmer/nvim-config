-- https://github.com/luals/lua-language-server
local settings = {
  Lua = {
    hint = {
      enable = true,
      arrayIndex = 'Disable',
    },
    diagnostics = {
      globals = { 'vim', 'USER_SETTINGS' },
    },
    workspace = {
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.stdpath('config') .. '/lua'] = true,
      },
      checkThirdParty = false,
    },
    format = {
      enabled = false,
    },
    completion = {
      callSnippet = 'Replace',
    },
  },
}

return {
  settings = settings,
}
