return {
  'Wansmer/langmapper',
  enabled = true,
  dir = '~/projects/code/personal/langmapper',
  dev = true,
  lazy = false,
  priority = 2,
  config = function()
    require('langmapper').setup({
      default_layout = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ{}:"abcdefghijklmnopqrstuvwxyz[];\',.',
      layouts = {
        ---@type table
        ru = {
          id = 'com.apple.keylayout.RussianWin',
          layout = 'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯХЪЖЭфисвуапршолдьтщзйкыегмцчняхъжэбю',
          leaders = {
            ['<LOCALLEADER>'] = 'ж',
            ['<LEADER>'] = false,
          },

          special_remap = {
            ['.'] = { rhs = '/', feed_mode = nil, check_layout = true },
            [','] = { rhs = '?', feed_mode = nil, check_layout = true },
            ['Ж'] = { rhs = ':', feed_mode = nil, check_layout = false },
            ['ж'] = { rhs = ';', feed_mode = nil, check_layout = false },
            ['ю'] = { rhs = '.', feed_mode = nil, check_layout = false },
            ['б'] = { rhs = ',', feed_mode = nil, check_layout = false },
            ['э'] = { rhs = "'", feed_mode = nil, check_layout = false },
            ['Э'] = { rhs = '"', feed_mode = nil, check_layout = false },
            ['х'] = { rhs = '[', feed_mode = nil, check_layout = false },
            ['ъ'] = { rhs = ']', feed_mode = nil, check_layout = false },
            ['Х'] = { rhs = '{', feed_mode = nil, check_layout = false },
            ['Ъ'] = { rhs = '}', feed_mode = nil, check_layout = false },
            ['ё'] = { rhs = '`', feed_mode = nil, check_layout = false },
            ['Ë'] = { rhs = '~', feed_mode = nil, check_layout = false },
          },
        },
      },
      os = {
        Darwin = {
          get_current_layout_id = function()
            local cmd = '/opt/homebrew/bin/im-select'
            local output = vim.split(vim.trim(vim.fn.system(cmd)), '\n')
            return output[#output]
          end,
        },
      },
    })
  end,
}
