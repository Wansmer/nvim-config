-- https://github.com/typescript-language-server/typescript-language-server/
-- See docs/configuration.md
return {
  -- autostart = not PREF.lsp.tom_enable,
  init_options = {
    hostInfo = "neovim",
    locale = "en",
    preferences = {
      providePrefixAndSuffixTextForRename = false,
      allowRenameOfImportPath = false,
    },
  },
  settings = {
    diagnostics = {
      --@type nuber[]
      ignoredCodes = {},
    },
    -- https://www.reddit.com/r/neovim/comments/14e41rb/comment/jou4ljw/?utm_source=share&utm_medium=web2x&context=3
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = false,
        includeInlayVariableTypeHints = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}
