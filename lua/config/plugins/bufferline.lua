return {
  'akinsho/bufferline.nvim',
  enabled = true,
  tag = 'v3.*',
  event = 'BufReadPre',
  config = function()
    local bufferline = require('bufferline')

    bufferline.setup({
      options = {
        mode = 'buffers',
        numbers = 'none',
        close_command = 'bdelete! %d',
        indicator = {
          icon = '▎',
          style = 'icon',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = false,
        offsets = { { filetype = 'neo-tree', text = 'File Explorer' } },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_buffer_default_icon = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = 'thick',
        enforce_regular_tabs = true,
        always_show_bufferline = true,
      },
    })
  end,
}
