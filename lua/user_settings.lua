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
      vimls = false,
      csharp_ls = false,
      prismals = true,
      eslint = true,
      lua_ls = true,
      -- tsserver = false,
      ts_ls = false, -- looks like tsserver has been renamed
      vtsls = true,
      volar = false,
      jsonls = true,
      cssls = true,
      tailwindcss = true,
      html = true,
      emmet_ls = true,
      bashls = true,
      dockerls = true,
      docker_compose_language_service = true,
      ltex = false,
      marksman = true,
      rust_analyzer = false,
      sqlls = false,
      sqls = true,
      clangd = false,
      gopls = true,
      ansiblels = false,
      basedpyright = true,
      pyright = false,
      ruff = true,
      typos_lsp = true,
      svelte = true,
    }),
  },

  ui = {
    ---(!) List of colorschemes lua/config/colorscheme/init.lua
    colorscheme = "serenity", -- If `.colorscheme` file exists, read name of colorscheme from it, otherwise use `PREF.ui.colorscheme
    border = { " ", " ", " ", " ", " ", " ", " ", " " },
    italic_comment = true,
  },

  git = {
    show_blame = false,
    show_signcolumn = true,
  },
}
