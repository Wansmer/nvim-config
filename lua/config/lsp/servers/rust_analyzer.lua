return {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = { enable = true },
      cargo = { features = 'all' },
      checkOnSave = true,
      check = { command = 'clippy' },
      inlayHints = {
        enabled = false,
        expressionAdjustmentHints = { enable = false }, -- do not enable
        bindingModeHints = { enable = false },
        chainingHints = { enable = false }, -- do not enable
        closingBraceHints = { enable = false },
        closureCaptureHints = { enable = false },
      },
      lens = {
        enable = true,
        methodReferences = true,
        references = true,
        implementations = false,
      },
    },
  },
}
