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
    escape_keys = { "jk", "JK", "jj" },
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
      lua_ls = true,
      tsserver = true,
      jsonls = true,
      cssls = true,
      tailwindcss = true,
      html = true,
      emmet_ls = true,
      bashls = true,
      dockerls = true,
      ltex = true,
      marksman = true,
      rust_analyzer = true,
      sqlls = true,
      clangd = true,
      gopls = false,
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
