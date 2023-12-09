local DEV = false

return {
  'Wansmer/treesj',
  enabled = true,
  dir = DEV and '~/projects/code/personal/treesj' or nil,
  dev = DEV,
  keys = { '<Leader>m', '<Leader>M', '<leader>s', '<leader>j' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local langs = require('treesj.langs').presets
    local lu = require('treesj.langs.utils')

    for _, nodes in pairs(langs) do
      nodes.comment = {
        both = {
          fallback = function(_)
            local res = require('mini.splitjoin').toggle()
            if not res then
              vim.cmd('normal! gww')
            end
          end,
        },
      }
    end

    local classnames = {
      both = {
        ---@param tsn TSNode
        enable = function(tsn)
          local parent = tsn:parent()
          if not parent or parent:type() ~= 'jsx_attribute' then
            return false
          end

          ---@diagnostic disable-next-line: param-type-mismatch (jsx_attribute with no children does not exist.)
          local attr_name = vim.treesitter.get_node_text(parent:child(0), 0)
          return attr_name == 'className'
        end,
      },
      split = {
        format_tree = function(tsj)
          local str = tsj:child('string_fragment')
          local words = vim.split(str:text(), ' ')
          tsj:remove_child('string_fragment')
          for i, word in ipairs(words) do
            tsj:create_child({ text = word }, i + 1)
          end
        end,
      },
    }

    local parenthesized_expression = lu.set_preset_for_args()

    require('treesj').setup({
      max_join_length = 1000,
      use_default_keymaps = true,
      langs = {
        tsx = {
          ['string'] = classnames,
          interface_declaration = { target_nodes = { 'object_type' } },
          parenthesized_expression = parenthesized_expression,
          return_statement = {
            target_nodes = {
              ['jsx_element'] = 'root_jsx_element',
              'jsx_self_closing_element',
              'parenthesized_expression',
            },
          },
          -- Not realy name of node
          root_jsx_element = lu.set_default_preset({
            split = {
              format_tree = function(tsj)
                tsj:wrap({ left = '(', right = ')' })
              end,
            },
            -- join = {
            --   enable = false,
            -- },
          }),
        },
        javascript = {
          ['string'] = classnames,
          parenthesized_expression = parenthesized_expression,
        },
      },
    })

    vim.keymap.set('n', '<Leader>M', function()
      require('treesj').toggle({ split = { recursive = true }, join = { recursive = true } })
    end, { desc = 'Toggle single/multiline block of code' })

    local function get_pos_lang(node)
      local c = vim.api.nvim_win_get_cursor(0)
      local range = { c[1] - 1, c[2], c[1] - 1, c[2] }
      local buf = vim.api.nvim_get_current_buf()
      local ok, parser = pcall(vim.treesitter.get_parser, buf, vim.treesitter.language.get_lang(vim.bo[buf].ft))
      if not ok then
        return ''
      end
      local current_tree = parser:language_for_range(range)
      return current_tree:lang()
    end

    vim.keymap.set('n', '<Leader>m', function()
      local tsj_langs = require('treesj.langs')['presets']
      local lang = get_pos_lang()
      if lang ~= '' and tsj_langs[lang] then
        require('treesj').toggle()
      else
        require('mini.splitjoin').toggle()
      end
    end)
  end,
}
