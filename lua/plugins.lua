-- Менеджер для работы с плагинами Packer
-- Репозиторий плагина: https://github.com/wbthomason/packer.nvim

local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_url = 'https://github.com/wbthomason/packer.nvim'
local cmd = { 'git', 'clone', '--depth', '1', packer_url, install_path }

-- Установка Packer, если он не установлен
if fn.empty(fn.glob(install_path)) > 0 then
  -- Клонирование репозитория Packer
  PACKER_BOOTSTRAP = fn.system(cmd)
  vim.cmd.packadd('packer.nvim')
end

local ok, packer = pcall(require, 'packer')

if not ok then
  return
end

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

  -- Нужны в первую очередь
  use({
    -- Менеджер плагинов
    'wbthomason/packer.nvim',
    -- Библиотека функций, как зависимость для остальных плагинов
    'nvim-lua/plenary.nvim',
    -- Иконки
    'nvim-tree/nvim-web-devicons',
    'lewis6991/impatient.nvim',
    {
      -- Улучшенные сообщения (ERROR, WARN e.t.c)
      'rcarriga/nvim-notify',
      config = function()
        require('config.plugins.notify')
      end,
    },
  })

  -- ==========================================================================
  -- LSP (Languate Server Protocol)
  -- ==========================================================================

  use({
    {
      -- Установщик для LSP-пакетов, линтеров, форматеров и т.д.
      'williamboman/mason.nvim',
      config = function()
        require('config.plugins.mason')
      end,
    },
    {
      -- Прослойка для взаимодействия lspconfig и mason
      'williamboman/mason-lspconfig.nvim',
      config = function()
        require('config.plugins.mason-lspconfig')
      end,
    },
    {
      -- Провайдер для внешних форматтеров вместо встроенных в lsp
      'jose-elias-alvarez/null-ls.nvim',
      config = function()
        require('config.plugins.null-ls')
      end,
    },
    {
      'jayp0521/mason-null-ls.nvim',
      config = function()
        require('config.plugins.mason-null-ls')
      end,
    },
    {
      -- Виджет для прогресса LSP
      'j-hui/fidget.nvim',
      config = function()
        require('config.plugins.fidget')
      end,
    },
    -- Сэмпл предустановок для LSP jsonls
    -- Обеспечивает дополнения для package.json, jsconfig и т.д.
    'b0o/SchemaStore.nvim',
    {
      -- Виртуальное окно для lsp defenitions, implementations и references
      'dnlhc/glance.nvim',
      config = function()
        require('config.plugins.glance')
      end,
    },
    {
      -- Конфигурация LSP
      'neovim/nvim-lspconfig',
      config = function()
        require('config.lsp')
      end,
      after = { 'mason.nvim', 'mason-lspconfig.nvim' },
    },
  })

  -- ==========================================================================
  -- Treesitter
  -- ==========================================================================

  -- Синтаксическое дерево
  use({
    {
      'nvim-treesitter/nvim-treesitter',
      run = function()
        require('nvim-treesitter.install').update({ with_sync = true })
      end,
      config = function()
        require('config.plugins.treesitter')
      end,
    },
    {
      -- AST дерево на основе treesitter
      'nvim-treesitter/playground',
      {
        -- Аннотации для функций (jsdoc и т.д.)
        'danymat/neogen',
        config = function()
          require('config.plugins.neogen')
        end,
      },
      after = { 'nvim-treesitter' },
    },
  })

  -- ==========================================================================
  -- Навигация (navigation)
  -- ==========================================================================

  use({
    {
      -- Файловый менеджер
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      requires = {
        'MunifTanjim/nui.nvim',
        {
          's1n7ax/nvim-window-picker',
          tag = 'v1.*',
          config = function()
            require('config.plugins.window-picker')
          end,
        },
      },
      config = function()
        require('config.plugins.neotree')
      end,
    },
    {
      -- Поиск всего и везде
      'nvim-telescope/telescope.nvim',
      tag = '0.1.0',
      config = function()
        require('config.plugins.telescope')
      end,
    },
    {
      -- Терминал
      'akinsho/toggleterm.nvim',
      tag = '*',
      config = function()
        require('config.plugins.toggleterm')
      end,
    },
    {
      -- Превью для файлов Markdown
      'iamcco/markdown-preview.nvim',
      run = 'cd app && npm install',
      setup = function()
        vim.g.mkdp_filetypes = { 'markdown' }
      end,
      ft = { 'markdown' },
    },
    -- Поддержка go to file (gf) в lua
    'sam4llis/nvim-lua-gf',
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
  -- Источники дополнений для cmp
  use({
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-document-symbol',
    'lukas-reineke/cmp-rg',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
    'folke/neodev.nvim',
    {
      'hrsh7th/cmp-nvim-lsp-signature-help',
      disable = not PREF.lsp.show_signature_on_insert,
    },
    requires = 'hrsh7th/nvim-cmp',
  })

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

  if PREF.ui.colorscheme ~= '' then
    use(colorschemes[PREF.ui.colorscheme])
  end

  use({
    {
      -- Внешний вид vim.input и vim.select
      'stevearc/dressing.nvim',
      config = function()
        require('config.plugins.dressing')
      end,
    },
    {
      -- Превью для цветовых кодов
      'NvChad/nvim-colorizer.lua',
      config = function()
        require('config.plugins.colorizer')
      end,
    },
    {
      -- Визуализация отступов
      'lukas-reineke/indent-blankline.nvim',
      config = function()
        require('config.plugins.blankline')
      end,
    },
    {
      -- Улучшенная подсветка совпадений под курсором
      'RRethy/vim-illuminate',
      config = function()
        require('config.plugins.illuminate')
      end,
    },
    {
      -- Управление буфферами, окнами, вкладками и их внешний вид
      'akinsho/bufferline.nvim',
      tag = 'v3.*',
      config = function()
        require('config.plugins.bufferline')
      end,
    },
    {
      -- Улучшенная строка состояния
      'nvim-lualine/lualine.nvim',
      config = function()
        require('config.plugins.lualine')
      end,
    },
    {
      -- Стартовый экран
      'goolord/alpha-nvim',
      config = function()
        require('config.plugins.alpha')
      end,
    },
  })

  -- ==========================================================================
  -- Улучшения редактора текста (Improve text editor)
  -- ==========================================================================

  local dev_mode = PREF.dev_mode
  local dev_branch = PREF.dev_branch
  local is_tsj = PREF.dev_plugin == 'treesj'
  local is_ss = PREF.dev_plugin == 'sibling-swap'
  local local_path = function(name)
    return '~/projects/code/personal/' .. name
  end
  local path_tsj = (dev_mode and is_tsj) and local_path('treesj')
    or 'Wansmer/treesj'
  local tsj_branch = is_tsj and (dev_branch or 'main') or 'main'

  local path_ss = (dev_mode and is_ss) and local_path('sibling-swap')
    or 'Wansmer/sibling-swap.nvim'
  local ss_branch = is_ss and (dev_branch or 'main') or 'main'

  use({
    -- Подсветка парных символов разными цветами
    {
      'p00f/nvim-ts-rainbow',
      after = 'nvim-treesitter',
    },
    -- Добавить/изменить парный тег
    {
      'windwp/nvim-ts-autotag',
      after = 'nvim-treesitter',
    },
    {
      -- Автосмена кавычек, если подразумевается интерполяция текста
      'axelvc/template-string.nvim',
      config = function()
        require('config.plugins.template-string')
      end,
      after = 'nvim-treesitter',
    },
    {
      -- Для сворачивания, разворачивания блоков кода
      path_tsj,
      branch = tsj_branch,
      config = function()
        require('config.plugins.treesj')
      end,
      after = 'nvim-treesitter',
    },
    {
      -- Перемена мест соседних узлов
      path_ss,
      branch = ss_branch,
      config = function()
        require('sibling-swap').setup()
      end,
      after = 'nvim-treesitter',
    },
    {
      -- Оборачивание в парные символы
      'kylechui/nvim-surround',
      config = function()
        require('nvim-surround').setup()
      end,
    },
    {
      -- Автоматическое закрытие парных символов
      'windwp/nvim-autopairs',
      disable = false,
      config = function()
        require('config.plugins.autopairs')
      end,
    },
    {
      -- Комментирование
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    },
  })

  -- Если packer установлен, запустить :PackerSync
  if PACKER_BOOTSTRAP then
    packer.sync()
  end
end)
