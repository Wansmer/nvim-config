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

  vim.cmd.packadd('packer.nvim')
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
  autoremove = true,
  display = {
    prompt_border = PREF.ui.border,
    compact = true,
  },
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

  -- Установщик для LSP-пакетов, линтеров, форматеров и т.д.
  use({
    'williamboman/mason.nvim',
  })

  -- Прослойка для взаимодействия lspconfig и mason
  use({
    'williamboman/mason-lspconfig.nvim',
  })

  -- Единый интерфейс для установки форматеров
  use({
    'jose-elias-alvarez/null-ls.nvim',
  })

  -- Сэмпл предустановок для LSP jsonls
  -- Обеспечивает дополнения для package.json, jsconfig и т.д.
  use({
    'b0o/SchemaStore.nvim',
  })

  -- Виджет для прогресса LSP
  use({
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({
        timer = {
          spinner_rate = 125, -- frame rate of spinner animation, in ms
          fidget_decay = 10000, -- how long to keep around empty fidget, in ms
          task_decay = 1000, -- how long to keep around completed task, in ms
        },
      })
    end,
  })

  -- Форматтер для embeded language
  -- fork
  use({
    -- 'Wansmer/null-ls-embedded',
    'LostNeophyte/null-ls-embedded',
    disable = false,
    config = function()
      require('null-ls-embedded').config({
        ignore_langs = {
          ['*'] = { 'comment', 'vim' }, -- ignore `comment` in all languages
          markdown = { 'markdown_inline' }, -- ignore `markdown_inline` in `markdown`
        },
        timeout = 1000,
      })
    end,
  })

  -- ==========================================================================
  -- Treesitter
  -- ==========================================================================

  -- Синтексическое дерево
  use({
    'nvim-treesitter/nvim-treesitter',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
    config = function()
      require('config.plugins.treesitter')
    end,
  })

  -- AST дерево на основе treesitter
  use('nvim-treesitter/playground')

  -- Аннотации для функций (jsdoc и т.д.)
  use({
    'danymat/neogen',
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('config.plugins.neogen')
    end,
  })

  -- ==========================================================================
  -- Навигация
  -- ==========================================================================

  -- Файловый менеджер
  use({
    'kyazdani42/nvim-tree.lua',
    disable = (PREF.file_explorer ~= 'nvim-tree'),
    config = function()
      require('config.plugins.nvimtree')
    end,
  })
  use({
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    disable = (PREF.file_explorer ~= 'neo-tree'),
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      {
        's1n7ax/nvim-window-picker',
        disable = (PREF.file_explorer ~= 'neo-tree'),
        tag = 'v1.*',
        config = function()
          require('config.plugins.window-picker')
        end,
      },
    },
    config = function()
      require('config.plugins.neotree')
    end,
  })

  -- Поиск всего и везде
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

  -- Поддержка go to file (gf) в lua
  use('sam4llis/nvim-lua-gf')

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
    'L3MON4D3/LuaSnip',
    'lukas-reineke/cmp-under-comparator',
    requires = 'hrsh7th/nvim-cmp',
  })

  -- Всплывающее окно с информацией о сигнатуре функции
  use({
    'hrsh7th/cmp-nvim-lsp-signature-help',
    requires = 'hrsh7th/nvim-cmp',
    disable = not PREF.lsp.show_signature_on_insert,
  })

  -- Документация в сигнатуре для vim.api
  use('folke/neodev.nvim')

  -- Библиотека сниппетов
  use('rafamadriz/friendly-snippets')

  -- ==========================================================================
  -- Оформление (UI, Colorschemes)
  -- ==========================================================================

  -- Цветовая схема
  local colorschemes = {
    catppuccin = {
      'catppuccin/nvim',
      as = 'catppuccin',
      run = ':CatppuccinCompile',
    },
    tundra = 'sam4llis/nvim-tundra',
    kanagawa = 'rebelot/kanagawa.nvim',
    tokyonight = 'folke/tokyonight.nvim',
    ['gruvbox-material'] = 'sainnhe/gruvbox-material',
    ['rose-pine'] = {
      'rose-pine/neovim',
      as = 'rose-pine',
    },
    nightfox = 'EdenEast/nightfox.nvim',
    dayfox = 'EdenEast/nightfox.nvim',
    dawnfox = 'EdenEast/nightfox.nvim',
    duskfox = 'EdenEast/nightfox.nvim',
    carbonfox = 'EdenEast/nightfox.nvim',
    nordfox = 'EdenEast/nightfox.nvim',
    terafox = 'EdenEast/nightfox.nvim',
    vscode = 'Mofiqul/vscode.nvim',
    mellow = 'kvrohit/mellow.nvim',
  }

  use(colorschemes[PREF.ui.colorscheme])

  -- Внешний вид vim.input и vim.select
  use({
    'stevearc/dressing.nvim',
    disable = false,
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

  -- Иконки
  use('kyazdani42/nvim-web-devicons')

  -- Визуализация отступов
  use({
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require('config.plugins.blankline')
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
    disable = false,
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

  -- TODO: настроить
  use({
    'rebelot/heirline.nvim',
    disable = true,
    config = function()
      require('config.plugins.heirline')
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

  -- Улучшенные сообщения (ERROR, WARN e.t.c)
  use({
    'rcarriga/nvim-notify',
    config = function()
      require('config.plugins.notify')
    end,
  })

  -- ==========================================================================
  -- Улучшения редактора текста (Improve text editor)
  -- ==========================================================================

  local dev_mode = PREF.dev_mode
  local dev_branch = PREF.dev_branch
  local is_tsj = PREF.dev_plugin == 'treesj'
  local is_bs = PREF.dev_plugin == 'binary-swap'
  local is_ss = PREF.dev_plugin == 'sibling-swap'
  local local_path = function(name)
    return '~/projects/code/personal/' .. name
  end

  -- Для сворачивания, разворачивания блоков кода
  local path_tsj = (dev_mode and is_tsj) and local_path('treesj')
    or 'Wansmer/treesj'
  local tsj_branch = is_tsj and (dev_branch or 'main') or 'main'
  use({
    path_tsj,
    branch = tsj_branch,
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('config.plugins.treesj')
    end,
  })

  -- Перемена мест операндов в бинарных выражениях
  local path_bs = (dev_mode and is_bs) and local_path('binary-swap')
    or 'Wansmer/binary-swap.nvim'
  local bs_branch = is_bs and (dev_branch or 'main') or 'main'
  use({
    path_bs,
    branch = bs_branch,
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      vim.keymap.set(
        'n',
        '<leader>v',
        require('binary-swap').swap_operands_with_operator
      )
      vim.keymap.set('n', '<leader>V', require('binary-swap').swap_operands)
    end,
  })

  -- Перемена мест соседних узлов
  local path_ss = (dev_mode and is_ss) and local_path('sibling-swap')
    or 'Wansmer/sibling-swap.nvim'
  local ss_branch = is_ss and (dev_branch or 'main') or 'main'
  use({
    path_ss,
    branch = ss_branch,
    requires = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('sibling-swap').setup()
    end,
  })

  -- Добавить/изменить парный тег
  use({ 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' })

  -- Подсветка парных символов разными цветами
  use({ 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' })

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
    disable = false,
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

  -- Если packer установлен, запустить :PackerSync
  if PACKER_BOOTSTRAP then
    packer.sync()
  end
end)
