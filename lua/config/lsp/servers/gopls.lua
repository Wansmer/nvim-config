return {
  settings = {
    gopls = {
      hints = {
        -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
