local util = require('lspconfig.util')
local cssls = require('config.lsp.servers.cssls')

local function get_typescript_server_path(root_dir)
  local global_ts = '/opt/homebrew/lib/node_modules/typescript/lib'
  local found_ts = ''
  local function check_dir(path)
    found_ts = util.path.join(path, 'node_modules', 'typescript', 'lib')
    if util.path.exists(found_ts) then
      return path
    end
  end
  if util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    return global_ts
  end
end

local tom_fts = {
  'vue',
  'typescript',
  'javascript',
  'javascriptreact',
  'typescriptreact',
  'json',
}

local vue_fts = {
  'vue',
}

local is_take_over_mode = PREF.lsp.tom_enable

local accepted_filetypes = is_take_over_mode and tom_fts or vue_fts

return {
  filetypes = accepted_filetypes,
  single_file_support = true,
  init_options = {
    languageFeatures = {
      completion = {
        defaultAttrNameCase = 'kebabCase',
        defaultTagNameCase = 'kebabCase',
      },
    },
  },
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
  settings = cssls.settings,
}
