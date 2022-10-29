PREF = {
  lsp = {
    -- форматирование при сохранении файла
    format_on_save = false,
    -- сообщения диагностики виртуальным текстом
    virtual_text = false,
    -- показывать сигнатуру сразу при вводе или по триггеру
    -- при включении запустить :PackerSync и перезапустить nvim
    show_signature_on_insert = false,
    -- показывать иконки диагностики
    show_diagnostic = true,
    -- показывать текущий контекст в коде в winbar
    show_current_context = true,
    -- использовать take_over_mode для проектов vue3
    -- настройка отключает отдельный tsserver и использует volar для .ts, .js и т.д.
    tom_enable = false,
  },
  ui = {
    -- catppuccin, tokyonight, kanagawa, nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox, aquarium
    colorscheme = 'catppuccin',
    -- Вид бордера для всплывающих окон. Может быть строкой или таблицей
    border = 'single',
  },
  -- при изменении запустить :PackerSync и перезапустить nvim
  file_explorer = 'neo-tree', -- nvim-tree, neo-tree
  git = {
    -- показывать информацию из git о текущей строке
    show_blame = false,
    show_signcolumn = true,
  },
}
