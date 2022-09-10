local present, configs = pcall(require, 'nvim-treesitter.configs')
if not present then
  return
end

configs.setup({
  ensure_installed = {
    'comment',
    'css',
    'dockerfile',
    'html',
    'javascript',
    'json',
    'lua',
    'make',
    'markdown',
    'regex',
    'scss',
    'tsx',
    'typescript',
    'yaml',
    'toml',
    'vue',
  },
  sync_install = false,
  ignore_install = { 'phpdoc' },
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = true,
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true },

  -- TREESITTER PLUGINS
  -- Autotag 'windwp/nvim-ts-autotag'
  autotag = {
    enable = true,
  },
  -- Rainbow 'windwp/nvim-ts-autotag'
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
})
