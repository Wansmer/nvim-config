-- https://github.com/luals/lua-language-server
-- https://github.com/LuaLS/lua-language-server/blob/16b9ce9bafbf0f432ab7d1d063e2f18b1ed0c947/doc/en-us/config.md

local settings = {
  Lua = {
    hint = {
      enable = true,
      arrayIndex = "Disable",
    },
    diagnostics = {
      globals = { "vim", "PREF" },
      disable = { "missing-fields" },
    },
    workspace = {
      library = {
        vim.fn.expand("$VIMRUNTIME/lua"),
        vim.fn.stdpath("config") .. "/lua",
      },
      checkThirdParty = false,
    },
    format = {
      enabled = false,
    },
    codeLens = {
      enable = false,
    },
    completion = {
      callSnippet = "Replace",
    },
  },
}

return {
  settings = settings,
}
