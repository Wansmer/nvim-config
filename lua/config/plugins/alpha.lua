return {
  'goolord/alpha-nvim',
  enabled = true,
  lazy = false,
  config = function()
    -- Основано на https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-1927405
    local alpha = require('alpha')
    local path = require('plenary.path')

    local dashboard = require('alpha.themes.dashboard')
    local nvim_web_devicons = require('nvim-web-devicons')
    local cdir = vim.fn.getcwd()

    local function get_extension(fn)
      local match = fn:match('^.+(%..+)$')
      local ext = ''
      if match ~= nil then
        ext = match:sub(2)
      end
      return ext
    end

    local function icon(fn)
      local nwd = require('nvim-web-devicons')
      local ext = get_extension(fn)
      return nwd.get_icon(fn, ext, { default = true })
    end

    local function colored_btn(sc, txt, cmd, hl)
      local btn = dashboard.button(sc, txt, cmd)
      btn.opts.hl_shortcut = hl or btn.opts.hl_shortcut
      return btn
    end

    local function file_button(fn, sc, short_fn)
      short_fn = short_fn or fn
      local ico_txt
      local fb_hl = {}

      local ico, hl = icon(fn)
      local hl_option_type = type(nvim_web_devicons.highlight)
      if hl_option_type == 'boolean' then
        if hl and nvim_web_devicons.highlight then
          table.insert(fb_hl, { hl, 0, 1 })
        end
      end
      if hl_option_type == 'string' then
        table.insert(fb_hl, { nvim_web_devicons.highlight, 0, 1 })
      end
      ico_txt = ico .. '  '

      local file_button_el = colored_btn(sc, ico_txt .. short_fn, '<cmd>e ' .. fn .. ' <CR>', 'Constant')
      local fn_start = short_fn:match('.*/')
      if fn_start ~= nil then
        table.insert(fb_hl, { 'Comment', #ico_txt - 2, #fn_start + #ico_txt - 1 })
      end
      file_button_el.opts.hl = fb_hl
      return file_button_el
    end

    local default_mru_ignore = { 'gitcommit' }

    local mru_opts = {
      ignore = function(c_path, ext)
        return (string.find(c_path, 'COMMIT_EDITMSG')) or (vim.tbl_contains(default_mru_ignore, ext))
      end,
    }

    --- @param cwd string optional
    --- @param items_number number optional number of items to generate, default = 10
    local function mru(cwd, items_number, opts)
      opts = opts or mru_opts
      items_number = items_number or 9

      local oldfiles = {}
      for _, v in pairs(vim.v.oldfiles) do
        if #oldfiles == items_number then
          break
        end
        local cwd_cond
        if not cwd then
          cwd_cond = true
        else
          cwd_cond = vim.startswith(v, cwd)
        end
        local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
        if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
          oldfiles[#oldfiles + 1] = v
        end
      end

      local target_width = 35

      local tbl = {}
      for index, file_name in ipairs(oldfiles) do
        local short_fn
        if cwd then
          short_fn = vim.fn.fnamemodify(file_name, ':.')
        else
          short_fn = vim.fn.fnamemodify(file_name, ':~')
        end

        if #short_fn > target_width then
          short_fn = path.new(short_fn):shorten(1, { -2, -1 })
          if #short_fn > target_width then
            short_fn = path.new(short_fn):shorten(1, { -1 })
          end
        end

        local file_button_el = file_button(file_name, ' ' .. index, short_fn)
        tbl[index] = file_button_el
      end
      return {
        type = 'group',
        val = tbl,
        opts = {},
      }
    end

    -- https://patorjk.com/software/taag/#p=display&h=0&v=0&f=ANSI%20Shadow&t=NEOVIM%0A
    local header_title = {
      '                                                     ',
      '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
      '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
      '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
      '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      '                                                     ',
    }

    local header = {
      type = 'text',
      val = header_title,
      opts = {
        shrink_margin = false,
        position = 'center',
      },
    }

    local section_mru = {
      type = 'group',
      val = {
        {
          type = 'text',
          val = 'Recent files',
          opts = {
            hl = 'SpecialComment',
            shrink_margin = false,
            position = 'center',
          },
        },
        { type = 'padding', val = 1 },
        {
          type = 'group',
          val = function()
            return { mru(cdir, 9) }
          end,
          opts = { shrink_margin = false },
        },
      },
    }

    local buttons = {
      type = 'group',
      val = {
        {
          type = 'text',
          val = 'Quick actions',
          opts = { hl = 'SpecialComment', position = 'center' },
        },
        { type = 'padding', val = 1 },
        colored_btn('f', '  Find file', ':Telescope find_files<CR>', 'Constant'),
        colored_btn('g', '  Find text', ':Telescope live_grep<CR>', 'Constant'),
        colored_btn('n', '  New file', ':ene <BAR> startinsert <CR>', 'Constant'),
        colored_btn('e', '  Open explorer', ':Neotree focus toggle <CR>', 'Constant'),
        colored_btn('c', '  Configuration', ':e ~/.config/nvim/init.lua <CR>', 'Constant'),
        colored_btn('u', '  Update plugins', ':Lazy sync<CR>', 'Constant'),
        colored_btn('q', '  Quit', ':qa<CR>', 'Constant'),
      },
      position = 'center',
    }

    local function config_info()
      -- local total_plugins = #vim.tbl_keys(packer_plugins)
      local total_plugins = require('lazy').stats().count
      local datetime = os.date(' %d-%m-%Y   %H:%M:%S')
      return datetime
        .. '   '
        .. total_plugins
        .. ' plugins'
        .. '   v'
        .. vim.version().major
        .. '.'
        .. vim.version().minor
        .. '.'
        .. vim.version().patch
    end

    local info = {
      type = 'text',
      val = config_info(),
      opts = {
        shrink_margin = false,
        position = 'center',
        hl = 'Constant',
      },
    }

    local opts = {
      layout = {
        { type = 'padding', val = 2 },
        header,
        { type = 'padding', val = 0 },
        info,
        { type = 'padding', val = 3 },
        section_mru,
        { type = 'padding', val = 2 },
        buttons,
      },
      opts = {
        margin = 5,
      },
    }
    alpha.setup(opts)
  end,
}
