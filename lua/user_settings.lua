local filter_clients = function(tbl)
  for k, v in pairs(tbl) do
    if not v then
      tbl[k] = nil
    end
  end
  return tbl
end

PREF = {
  common = {
    textwidth = 100,
    tabwidth = 2,
  },

  lsp = {
    format_on_save = false,
    virtual_text = false,
    show_diagnostic = true,
    show_inlay_hints = true,
    -- Use take_over_mode for Vue projects or not
    tom_enable = false,
    -- List of servers to run
    -- Also applies to `ensure_installed` in `mason-lspconfig`
    active_servers = filter_clients({
      eslint = false,
      lua_ls = true,
      tsserver = true,
      volar = false,
      jsonls = true,
      cssls = true,
      tailwindcss = true,
      html = true,
      emmet_ls = true,
      bashls = true,
      dockerls = false,
      ltex = false,
      marksman = true,
      rust_analyzer = false,
      sqlls = false,
      clangd = false,
      gopls = false,
      ansiblels = true,
    }),
  },

  ui = {
    ---(!) List of colorschemes lua/config/colorscheme/init.lua
    colorscheme = "serenity",
    border = { " ", " ", " ", " ", " ", " ", " ", " " },
    italic_comment = true,
  },

  git = {
    show_blame = false,
    show_signcolumn = true,
  },
}
