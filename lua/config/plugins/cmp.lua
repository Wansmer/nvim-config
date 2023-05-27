local icons = {
  Text = '',
  Method = 'm',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = '',
  Interface = '',
  Module = '',
  Property = '',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

return {
  'hrsh7th/nvim-cmp',
  enabled = true,
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-document-symbol',
    'lukas-reineke/cmp-under-comparator',
    'lukas-reineke/cmp-rg',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
    {
      'hrsh7th/cmp-nvim-lsp-signature-help',
      enabled = PREF.lsp.show_signature_on_insert,
    },
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    require('luasnip/loaders/from_vscode').lazy_load()

    cmp.setup({
      preselect = 'None',
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          require('cmp-under-comparator').under,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-y>'] = cmp.config.disable,
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<C-x>'] = cmp.mapping(cmp.mapping.complete({}), { 'i', 'c' }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand({})
          -- elseif luasnip.expand_or_jumpable() then
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      formatting = {
        fields = {
          'kind',
          'abbr',
          'menu',
        },
        format = function(entry, vim_item)
          vim_item.kind = string.format('%s', icons[vim_item.kind])
          vim_item.menu = ({
            nvim_lsp = 'lsp ',
            luasnip = 'snip',
            buffer = 'buff',
            path = 'path',
            cmdline = 'cmd ',
            cmdline_history = 'hist',
            nvim_lsp_document_symbol = 'sym ',
            rg = 'rg  ',
          })[entry.source.name]
          return vim_item
        end,
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        {
          name = 'buffer',
          option = {
            -- uses 'iskeyword' to indicate words for completion
            keyword_pattern = [[\k\+]],
            -- completion from all visible buffers
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
        { name = 'path' },
        { name = 'nvim_lsp_signature_help' },
        {
          name = 'rg',
          keyword_length = 3,
        },
        { name = 'crates' },
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      window = {
        completion = {
          border = 'none',
        },
        documentation = {
          border = PREF.ui.border,
        },
      },
      experimental = {
        ghost_text = false,
      },

      view = {
        entries = {
          name = 'custom',
          selection_order = 'top_down',
        },
      },
    })

    local cmd_mapping = {
      ['<C-n>'] = function()
        local key = vim.api.nvim_replace_termcodes('<Down>', true, true, true)
        vim.api.nvim_feedkeys(key, 'n', true)
      end,
      ['<C-p>'] = function()
        local key = vim.api.nvim_replace_termcodes('<Up>', true, true, true)
        vim.api.nvim_feedkeys(key, 'n', true)
      end,
    }

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(cmd_mapping),
      sources = {
        { name = 'buffer' },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(cmd_mapping),
      sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
    })
  end,
}
