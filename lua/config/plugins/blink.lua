return {
  "saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    { "rafamadriz/friendly-snippets" },
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      config = function()
        -- Based on: https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lua/plugins/nvim-cmp.lua
        local luasnip = require("luasnip")

        -- See spec: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#snippet_syntax
        local vscode_snippets = require("luasnip.loaders.from_vscode")
        vscode_snippets.lazy_load() -- Load snippets from friendly-snippets
        vscode_snippets.lazy_load({ paths = { "~/.config/nvim/snippets" } }) -- custom snippets

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
  },
  cond = true, -- disable, bun not deleted from .local/share/...
  enabled = true, -- completely deleted plugin
  version = "1.*",
  config = function()
    local u = require("utils")
    local ls = require("luasnip")
    require("blink.cmp").setup({
      keymap = {
        preset = "default",
        ["<C-x>"] = { "show", "hide", "show_documentation", "hide_documentation" },
        ["<Tab>"] = {
          function(ctx)
            if ctx.is_visible() then
              return ctx.select_next()
            elseif ls.jumpable(1) then
              vim.schedule(function()
                ls.jump(1)
              end)
              return true -- Return true to stop next run
            end
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function(ctx)
            if ctx.is_visible() then
              return ctx.select_prev()
            elseif ls.jumpable(-1) then
              vim.schedule(function()
                ls.jump(-1)
              end)
              return true -- Return true to stop next run
            end
          end,
          "fallback",
        },
        ["<C-y>"] = { "accept", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        menu = {
          auto_show = true,
          draw = {
            align_to = "none",
            columns = {
              { "kind_icon", "label", "label_description", gap = 1 },
              { "source_name" },
            },
            padding = { 1, 0 },
            treesitter = { "lsp" },
            components = {
              source_name = {
                text = function(ctx)
                  return "" .. u.pad_end(ctx.source_name, 4) .. ""
                end,
              },
            },
          },
        },
        ghost_text = { enabled = false },
        documentation = { auto_show = true },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            name = "Lsp",
            module = "blink.cmp.sources.lsp",
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                return item.kind ~= require("blink.cmp.types").CompletionItemKind.Keyword
              end, items)
            end,
          },
          snippets = {
            name = "Snip",
            module = "blink.cmp.sources.snippets",
          },
          buffer = {
            name = "Buff",
            module = "blink.cmp.sources.buffer",
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
          },
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },

      signature = {
        enabled = true,
      },

      cmdline = {
        keymap = { preset = "cmdline" },
        completion = {
          menu = {
            auto_show = function(_)
              return vim.fn.getcmdtype() == ":"
            end,
          },
        },
      },
    })
  end,
}
