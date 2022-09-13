return {
  -- filetypes = {
  --   'vue',
  -- Для takeOverMode
  -- 'typescript',
  -- 'javascript',
  -- 'javascriptreact',
  -- 'typescriptreact',
  -- 'json',
  -- },
  -- init_options = {
  --   typescript = {
  --     -- TODO: сделать динамический поиск глобально установленного пакета
  --     serverPath = '/Users/wansmer/.nvm/versions/node/v16.15.0/lib/node_modules/typescript/lib/tsserverlibrary.js',
  --   },
  -- },
  on_new_config = function(new_config)
    new_config.init_options.typescript.serverPath =
      '/Users/wansmer/.nvm/versions/node/v16.15.0/lib/node_modules/typescript/lib/tsserverlibrary.js'
  end,
}
