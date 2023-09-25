return {
  'barreiroleo/ltex-extra.nvim',
  enabled = true,
  event = 'LspAttach',
  init = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'Exta-ltex: update ltex lsp-config',
      callback = function(e)
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if client and client.name == 'ltex' then
          require('ltex_extra').setup({
            -- https://valentjn.github.io/ltex/supported-languages.html#natural-languages
            load_langs = { 'en-US', 'ru-RU' }, -- en-US as default
            -- boolean : whether to load dictionaries on startup
            init_check = true,
            -- string : relative or absolute path to store dictionaries
            path = '.ltex', -- project root or current working directory
            -- string : "none", "trace", "debug", "info", "warn", "error", "fatal"
            log_level = 'none',
          })
        end
      end,
    })
  end,
}
