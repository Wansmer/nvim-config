# Конфигурация для Neovim 0.8+

## Зависимости

**Neovim 0.8.+** ([Nightly](https://github.com/neovim/neovim/releases/nightly))

```bash
brew install neovim --HEAD
```

### Опционально

#### Nerdfonts

Nerdfont нужен для отображения иконок типов файлов, бордеров, специальных знаков
и т.д. Можно установить любой [на свой вкус](https://www.nerdfonts.com),
например `JetBrains Mono Nerd Font`.

#### Линтеры

```bash
npm i -g eslint stylelint
brew install stylua
```

## Установка

1. Клонируйте этот репозиторий в `~/.config/nvim`:

```bash
git clone https://github.com/Wansmer/tmp.git ~/.config/nvim
```

2. Запустите nvim. При первом запуске будет установлен [Packer](https://github.com/wbthomason/packer.nvim), [плагины](/lua/plugins.lua), клиенты LSP и парсеры treesitter:

```bash
nvim
```

3. Перезапустите neovim, чтобы применились настройки установленных плагинов.
