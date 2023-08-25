return {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = { enable = true },
      cargo = { features = 'all' },
      checkOnSave = true,
      check = { command = 'clippy' },
      inlayHints = {
        expressionAdjustmentHints = { enable = false },
        bindingModeHints = { enable = true },
        chainingHints = { enable = false },
        closingBraceHints = { enable = true },
        closureCaptureHints = { enable = true },
      },
    },
  },
}
