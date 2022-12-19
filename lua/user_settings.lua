-- Специальные указания:
-- Любые изменения применятся только после перезапуска neovim;
-- (!) После изменения параметра в восклицаетльным знаком нужно запусить :PackerSync и перезапустить neovim;

PREF = {
  common = {
    textwidth = 120,
    tabwidth = 2,
    escape_keys = 'jk',
  },

  lsp = {
    -- форматирование при сохранении файла
    format_on_save = false,

    -- сообщения диагностики виртуальным текстом
    virtual_text = false,

    -- (!) показывать сигнатуру сразу при вводе или по триггеру
    show_signature_on_insert = false,

    -- показывать иконки диагностики
    show_diagnostic = true,

    -- показывать текущий контекст в коде в winbar
    show_current_context = true,

    -- использовать take_over_mode для проектов vue3
    -- настройка отключает отдельный tsserver и использует volar для .ts, .js и т.д.
    tom_enable = true,

    -- (!)серверы, которые будут установлены по по умолчанию
    -- если сервер требует доп.настроек, то нужно поместить одноименный файл с настройками
    -- в lua/config/lsp/servers
    preinstall_servers = {
      'sumneko_lua',
      'tsserver',
      'volar',
      'cssls',
      'html',
      'emmet_ls',
      'jsonls',
      'marksman',
      'rust_analyzer',
    },
  },

  ui = {
    -- (!) список поддерживаемых тем: lua/config/colorscheme/init.lua
    ---@type 'tundra'|'tokyonight'|'catppuccin'|'kanagawa'|'nightfox'|'gruvbox-material'
    colorscheme = 'gruvbox-material',

    -- Вид бордера для всплывающих окон. Может быть строкой или таблицей
    border = 'single',

    -- Cursive comment
    italic_comment = true,
  },

  git = {
    -- показывать информацию из git о текущей строке
    show_blame = false,
    show_signcolumn = true,
  },

  -- (!) использую, чтобы вручную не менять адрес своих плагинов в plugins.lua
  dev_mode = false,
  -- boolean|string какую ветку загружать
  dev_branch = false,
  -- имя плагина
  dev_plugin = '',
}
