PREF = {
  common = {
    textwidth = 100,
    tabwidth = 2,
    escape_keys = { 'jk', 'JK', 'jj' },
  },

  lsp = {
    format_on_save = false,
    virtual_text = false,
    -- show_signature_on_insert = true,
    show_diagnostic = true,
    -- Use take_over_mode for vue projects or not
    tom_enable = true,
    preinstall_servers = {
      'volar',
      'tsserver',
      'lua_ls',
      'html',
      'emmet_ls',
      'marksman',
      'cssls',
      'jsonls',
      'rust_analyzer',
      'sqlls',
      'bashls',
      'dockerls',
    },
  },

  ui = {
    ---(!) List of colorschemes lua/config/colorscheme/init.lua
    colorscheme = 'serenity',
    border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    italic_comment = true,
  },

  git = {
    show_blame = false,
    show_signcolumn = true,
  },
}
