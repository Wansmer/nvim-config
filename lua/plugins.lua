-- Менеджер для работы с плагинами Packer
-- Репозиторий плагина: https://github.com/wbthomason/packer.nvim

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

-- Установка Packer, если он не установлен
if fn.empty(fn.glob(install_path)) > 0 then
  -- Клонирование репозитория Packer
  PACKER_BOOTSTRAP = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })

  vim.cmd([[packadd packer.nvim]])
end

local ok, packer = pcall(require, 'packer')

if not ok then
  return
end

-- Применить изменения этого файла при сохранении и синхронизировать плагины
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

packer.init({
  max_jobs = 50,
  prompt_border = USER_SETTINGS.ui.border,
  autoremove = true,
})

return packer.startup(function(use)
  -- ==========================================================================
  -- Главное (Main)
  -- ==========================================================================

  -- Загрузка менеджера пакетов
  use('wbthomason/packer.nvim')
  -- Вспомогательная библиотека для плагинов
  use('nvim-lua/plenary.nvim')

  -- ==========================================================================
  -- LSP (Languate Server Protocol)
  -- ==========================================================================

  -- Конфигурация LSP
  use({
    'neovim/nvim-lspconfig',
    config = function()
      require('config.lsp')
    end,
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
  })
  -- Установщик для LSP-пакетов
  use({
    'williamboman/mason.nvim',
  })
  -- Прослойка для взаимодействия lspconfig и mason
  use({
    'williamboman/mason-lspconfig.nvim',
  })
  -- Единый интерфейс для форматирования с помощью LSP
  use({
    'jose-elias-alvarez/null-ls.nvim',
  })
  -- Адаптер для tsserver
  use({ 'jose-elias-alvarez/typescript.nvim' })
  -- Сэмпл предустановок для LSP jsonls
  -- Обеспечивает дополнения для package.json, jsconfig и т.д.
  use({
    'b0o/SchemaStore.nvim',
  })

  -- ==========================================================================
  -- Treesitter
  -- ==========================================================================

  -- Умная подсветка синтаксиса на основе синтактического дерева
  use({
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
    config = function()
      require('config.plugins.treesitter')
    end,
  })
  -- Добавить/изменить парный тег
  use({ 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' })
  -- Подсветка парных символов разными цветами
  use({ 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' })

  -- ==========================================================================
  -- Навигация
  -- ==========================================================================

  -- Файловый менеджер
  use({
    'kyazdani42/nvim-tree.lua',
    disable = (USER_SETTINGS.file_explorer ~= 'nvim-tree'),
    config = function()
      require('config.plugins.nvimtree')
    end,
  })
  use({
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    disable = (USER_SETTINGS.file_explorer ~= 'neo-tree'),
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      {
        's1n7ax/nvim-window-picker',
        tag = 'v1.*',
        config = function()
          require('window-picker').setup({
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = {
                  'neo-tree',
                  'neo-tree-popup',
                  'notify',
                  'quickfix',
                  'toggleterm',
                },

                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal', 'toggleterm' },
              },
            },
            other_win_hl_color = '#e35e4f',
          })
        end,
      },
    },
    config = function()
      require('config.plugins.neotree')
    end,
  })

  -- Центральное всплывающее окно с огромным функционалом
  use({
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('config.plugins.telescope')
    end,
  })

  -- Терминал
  use({
    'akinsho/toggleterm.nvim',
    tag = 'v2.*',
    config = function()
      require('config.plugins.toggleterm')
    end,
  })

  -- Превью для файлов Markdown
  use({
    'iamcco/markdown-preview.nvim',
    run = 'cd app && npm install',
    setup = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  })

  -- ==========================================================================
  -- Git
  -- ==========================================================================

  -- Визуальное отображение статуса git
  use({
    'lewis6991/gitsigns.nvim',
    config = function()
      require('config.plugins.gitsigns')
    end,
  })

  -- ==========================================================================
  -- TODO: Дебагинг (Debug)
  -- ==========================================================================

  -- ==========================================================================
  -- Автодополнение (Completion)
  -- ==========================================================================

  -- Дополнение кода
  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('config.plugins.cmp')
    end,
  })
  use({
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'L3MON4D3/LuaSnip',
    requires = 'hrsh7th/nvim-cmp',
  })
  use({
    'hrsh7th/cmp-nvim-lsp-signature-help',
    requires = 'hrsh7th/nvim-cmp',
    disable = not USER_SETTINGS.lsp.show_signature_on_insert,
  })
  -- Библиотека сниппетов
  use('rafamadriz/friendly-snippets')

  -- ==========================================================================
  -- Оформление (UI, Colorschemes)
  -- ==========================================================================

  -- Цветовая схема
  use('rebelot/kanagawa.nvim')
  use('folke/tokyonight.nvim')
  use('EdenEast/nightfox.nvim')
  use('frenzyexists/aquarium-vim')
  use({
    'catppuccin/nvim',
    as = 'catppuccin',
    run = ':CatppuccinCompile',
  })
  -- Внешний вид vim.input и vim.select
  use({
    'stevearc/dressing.nvim',
    config = function()
      require('config.plugins.dressing')
    end,
  })
  -- Превью для цветовых кодов
  use({
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('config.plugins.colorizer')
    end,
  })
  -- Улучшает вид colorcolumn
  use({
    'xiyaowong/virtcolumn.nvim',
    config = function()
      vim.g.virtcolumn_char = '▕' -- char to display the line
      vim.g.virtcolumn_priority = 10 -- priority of extmark
    end,
  })
  -- Иконки
  use('kyazdani42/nvim-web-devicons')
  -- Убирает подсветку поиска по буфферу, когда уже не надо
  use('romainl/vim-cool')
  -- Визуализация отступов
  use('lukas-reineke/indent-blankline.nvim')
  -- Визуализация фолдинга
  use({
    'kevinhwang91/nvim-ufo',
    disable = false,
    requires = 'kevinhwang91/promise-async',
    config = function()
      require('config.plugins.ufo')
    end,
  })
  -- Улучшенная подсветка совпадений под курсором
  use({
    'RRethy/vim-illuminate',
    config = function()
      require('config.plugins.illuminate')
    end,
  })
  -- Управление буфферами, окнами, вкладками и их внешний вид
  use({
    'akinsho/bufferline.nvim',
    tag = 'v2.*',
    config = function()
      require('config.plugins.bufferline')
    end,
  })
  -- Улучшенная строка состояния
  use({
    'nvim-lualine/lualine.nvim',
    disable = false,
    config = function()
      require('config.plugins.lualine')
    end,
  })
  -- Стартовый экран
  use({
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      require('config.plugins.alpha')
    end,
  })

  -- ==========================================================================
  -- Улучшения редактора текста (Improve text editor)
  -- ==========================================================================

  -- Разворачивание/Сворачивание объектов, функций и т.д.
  use('AndrewRadev/splitjoin.vim')
  -- Замена значения на противоположное (тригер <leader>i)
  use({
    'nguyenvukhang/nvim-toggler',
    config = function ()
      require('nvim-toggler').setup()
    end
  })
  -- Автосмена кавычек, если подразумевается интерполяция текста
  use({
    'axelvc/template-string.nvim',
    config = function()
      require('config.plugins.template-string')
    end,
  })
  -- Оборачивание в парные символы
  use({
    'kylechui/nvim-surround',
    config = function()
      require('nvim-surround').setup()
    end,
  })
  -- Автоматическое закрытие парных символов
  use({
    'windwp/nvim-autopairs',
    config = function()
      require('config.plugins.autopairs')
    end,
  })
  -- Комментирование
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  })
  -- Прыжок из закрытых парных символов
  use({
    'abecodes/tabout.nvim',
    config = function()
      require('tabout').setup({
        tabkey = '<C-f>',
        act_as_tab = false,
      })
    end,
    requires = { 'nvim-treesitter' },
  })

  -- Если packer установлен, запустить :PackerSync
  if PACKER_BOOTSTRAP then
    packer.sync()
  end
end)
