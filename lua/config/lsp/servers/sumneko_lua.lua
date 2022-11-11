require('neodev').setup({})

local settings = {
  Lua = {
    diagnostics = {
      globals = { 'vim', 'packer_plugins', 'USER_SETTINGS' },
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
