local util = require('lspconfig.util')

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

local known_ts_paths = {
  {
    name = 'local',
    paths = {
      '/node_modules/typescript/lib/tsserverlibrary.js',
    },
  },
  {
    name = 'mason',
    paths = {
      '/.local/share/nvim/mason/packages/typescript-language-server/node_modules/typescript/lib/tsserverlibrary.js',
    },
  },
  {
    name = 'global',
    paths = {
      '/.npm/lib/node_modules/typescript/lib/tsserverlibrary.js',
    },
  },
  {
    name = 'nvm',
    paths = {
      '/.nvm/versions/node/v16.15.0/lib/node_modules/typescript/lib/tsserverlibrary.js',
    },
  },
}

local function build_path(source, preffer, root_dir)
  local case = preffer or source.name
  local home = vim.fn.getenv('HOME')
  if case == 'local' then
    return root_dir .. source.paths[1]
    -- TODO: разобраться с получением версии node
    -- elseif case == 'nvm' then
    -- local versions = vim.cmd('silent exec "!node -v"')
    -- print(string.format(source.paths[1], vim.cmd('!node -v')))
    -- return home .. '/.nvm/versions/node/v16.15.0/lib/node_modules/typescript/lib/tsserverlibrary.js'
  else
    return home .. source.paths[1]
  end
end

local function find_ts_path(root_dir)
  root_dir = root_dir or ''
  for _, value in ipairs(known_ts_paths) do
    local path_to_search = build_path(value, false, root_dir)
    local is_found = util.path.exists(path_to_search)
    if is_found then
      vim.notify(
        'TS is found at \n'
          .. path_to_search
          .. '\n with sourse ['
          .. value.name
          .. ']'
      )
      return path_to_search
    end
  end
  vim.notify('TS not found at knowns paths. Volar no use typescript now')
  return ''
end

return {
  filetypes = accepted_filetypes,
  init_options = {
    languageFeatures = {
      completion = {
        defaultAttrNameCase = 'kebabCase',
        defaultTagNameCase = 'kebabCase',
      },
    },
  },
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.serverPath = find_ts_path(new_root_dir)
  end,
}
