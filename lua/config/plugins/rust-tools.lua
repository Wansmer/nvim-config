return {
  'simrat39/rust-tools.nvim',
  dependencies = { 'neovim/nvim-lspconfig' },
  ft = { 'rust' },
  config = function()
    local rt = require('rust-tools')

    rt.setup({
      tools = {
        inlay_hints = {
          show_parameter_hints = true,
          only_current_line = true,
          parameter_hints_prefix = '<- ',
          other_hints_prefix = '=> ',
          right_align = false,
        },
        hover_actions = {
          border = 'none',
        },
      },
      server = {
        -- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
        settings = {
          ['rust-analyzer'] = {
            cargo = {
              features = 'all',
            },
            checkOnSave = true,
            check = {
              command = 'clippy',
            },
            inlayHints = {
              expressionAdjustmentHints = {
                enable = true,
              },
            },
          },
        },
        on_attach = function(_, bufnr)
          -- Remap defaul hover and code_actions keybindings
          vim.keymap.set('n', '<Leader>lh', rt.hover_actions.hover_actions, { buffer = bufnr })
          vim.keymap.set('n', '<Leader>lA', rt.code_action_group.code_action_group, { buffer = bufnr })
        end,
      },
    })
  end,
}
