local present, cmp = pcall(require, 'cmp')
if not present then
  return
end

local snip_status_ok, luasnip = pcall(require, 'luasnip')
if not snip_status_ok then
  return
end

local cuc = require('cmp-under-comparator')

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

require('luasnip/loaders/from_vscode').lazy_load()

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

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-x>'] = cmp.mapping(cmp.mapping.complete({}), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand({})
      elseif luasnip.expand_or_jumpable() then
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
        nvim_lsp_document_symbol = 'sym ',
        rg = 'rg  ',
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    {
      name = 'nvim_lsp',
      priority = 9,
    },
    {
      name = 'luasnip',
      priority = 8,
    },
    {
      name = 'buffer',
      priority = 7,
    },
    {
      name = 'path',
      priority = 2,
    },
    {
      name = 'nvim_lsp_signature_help',
    },
    {
      name = 'rg',
      keyword_length = 4,
      priority = 1,
    },
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
    ghost_text = true,
    native_menu = false,
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cuc.under,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = 'nvim_lsp_document_symbol' } },
    { { name = 'buffer' } }
  ),
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources(
    { { name = 'path' } },
    { { name = 'cmdline' } }
  ),
})
