USER_SETTINGS = {
  lsp = {
    -- форматирование при сохранении файла
    format_on_save = true,
    -- сообщения диагностики виртуальным текстом
    virtual_text = false,
    -- показывать сигнатуру сразу при вводе или по триггеру
    -- при включении запустить :PackerSync и перезапустить nvim
    show_signature_on_insert = false,
    -- показывать иконки диагностики
    show_diagnostic = true,
  },
  ui = {
    -- catppuccin, tokyonight, kanagawa, nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox, aquarium
    colorscheme = 'catppuccin',
    -- Вид бордера для всплывающих окон. Может быть строкой или таблицей
    border = 'single',
  },
  -- при изменении запустить :PackerSync и перезапустить nvim
  file_explorer = 'neo-tree', -- nvim-tree, neo-tree
}
