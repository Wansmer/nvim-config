-- Специальные указания:
-- Любые изменения применятся только после перезапуска neovim;
-- (!) После изменения параметра в восклицаетльным знаком нужно перезапустить neovim;

PREF = {
  common = {
    textwidth = 120,
    tabwidth = 2,
    escape_keys = { 'jk', 'JK', 'jj' },
  },

  lsp = {
    -- форматирование при сохранении файла
    format_on_save = false,

    -- сообщения диагностики виртуальным текстом
    virtual_text = false,

    -- (!) показывать сигнатуру сразу при вводе или по триггеру
    show_signature_on_insert = true,

    -- показывать иконки диагностики
    show_diagnostic = true,

    -- использовать take_over_mode для проектов vue3
    -- настройка отключает отдельный tsserver и использует volar для .ts, .js и т.д.
    tom_enable = true,
  },

  ui = {
    -- (!) список поддерживаемых тем: lua/config/colorscheme/init.lua
    colorscheme = 'tundra',

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
