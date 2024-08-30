local icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
  Codeium = "",
}

return {
  "hrsh7th/nvim-cmp",
  enabled = true,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "lukas-reineke/cmp-under-comparator",
    "lukas-reineke/cmp-rg",
    "folke/lazydev.nvim",
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      config = function()
        -- Based on: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/plugins/nvim-cmp.lua
        local luasnip = require("luasnip")

        vim.api.nvim_create_autocmd("ModeChanged", {
          group = vim.api.nvim_create_augroup("luasnip.config", { clear = true }),
          pattern = { "i:n", "s:n" },
          callback = function(e)
            if
              luasnip.session
              and luasnip.session.current_nodes[e.buf]
              and not luasnip.session.jump_active
              and not luasnip.choice_active()
            then
              luasnip.active_update_dependents()
              luasnip.unlink_current()
            end
          end,
        })
      end,
    },
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    local luasnip = require("luasnip")
    -- See spec: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#snippet_syntax
    local vscode_snippets = require("luasnip.loaders.from_vscode")
    vscode_snippets.lazy_load() -- Load snippets from friendly-snippets
    vscode_snippets.lazy_load({ paths = { "~/.config/nvim/snippets" } }) -- custom snippets

    cmp.setup({
      preselect = "None",
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-y>"] = cmp.config.disable,
        ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
        ["<C-x>"] = cmp.mapping.complete(),
        ["<C-v>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
      formatting = {
        fields = {
          "kind",
          "abbr",
          "menu",
        },
        format = function(entry, vim_item)
          local tt_ok, tt = pcall(require, "tailwind-tools.cmp")
          if tt_ok then
            -- colorize tailwind classes
            vim_item = tt.lspkind_format(entry, vim_item)
          end
          vim_item.kind = string.format("%s", icons[vim_item.kind])
          vim_item.menu = ({
            nvim_lsp = "lsp ",
            codeium = "ai  ",
            luasnip = "snip",
            buffer = "buff",
            path = "path",
            cmdline = "cmd ",
            cmdline_history = "hist",
            nvim_lsp_document_symbol = "sym ",
            rg = "rg  ",
            ["html-css"] = "css ",
          })[entry.source.name]
          return vim_item
        end,
      },
      sources = {
        { name = "codeium" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        {
          -- See: https://github.com/hrsh7th/cmp-buffer#all-buffers
          name = "buffer",
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
        {
          name = "path",
          trigger_characters = { "/", "~", "./", "../" },
        },
        { name = "rg" },
        { name = "crates" },
        {
          name = "html-css",
          option = {
            max_count = {}, -- not ready yet
            enable_on = {
              "html",
              "vue",
              "svelte",
              "typescript",
              "javascript",
              "javascriptreact",
              "typescriptreact",
            }, -- set the file types you want the plugin to work on
            file_extensions = { "css", "scss", "sass", "less" }, -- set the local filetypes from which you want to derive classes
          },
        },
        { name = "lazydev", group_index = 0 },
      },
      confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
      },
      window = {
        completion = {
          border = "none",
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
          name = "custom",
          selection_order = "top_down",
        },
      },
    })

    local cmd_mapping = {
      ["<C-n>"] = function()
        local key = vim.api.nvim_replace_termcodes("<Down>", true, true, true)
        vim.api.nvim_feedkeys(key, "n", true)
      end,
      ["<C-p>"] = function()
        local key = vim.api.nvim_replace_termcodes("<Up>", true, true, true)
        vim.api.nvim_feedkeys(key, "n", true)
      end,
    }

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(cmd_mapping),
      sources = {
        { name = "buffer" },
      },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(cmd_mapping),
      sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
    })
  end,
}
