local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

-- local function current_layout()
--   local cmd =
--     'defaults read-type ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID'
--
--   local output = vim.split(vim.trim(vim.fn.system(cmd)), '\n')
--
--   local layouts = {
--     ['com.apple.keylayout.RussianWin'] = 'Ru',
--     ['com.apple.keylayout.ABC'] = 'En',
--   }
--
--   return layouts[output[#output]]
-- end

local function lsp_list()
  local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })

  if next(buf_clients) == nil then
    return 'No LSP attached'
  end

  local buf_client_names = {}

  -- Получает все клиенты LSP, которые не null-ls
  for _, client in pairs(buf_clients) do
    if client.name ~= 'null-ls' then
      table.insert(buf_client_names, client.name)
    end
  end

  return table.concat(buf_client_names, ', ')
end

local function formatters_list()
  local formatters = require('config.lsp.formatters')
  local buf_ft = vim.bo.filetype
  local supported_formatters = formatters.list_registered(buf_ft)
  return table.concat(supported_formatters, ', ')
end

local lsp_servers = {
  lsp_list,
  icon = ' LSP:',
  icons_enabled = true,
}

local formatters = {
  formatters_list,
  icon = ' Formatter:',
  icons_enabled = true,
}

local filetype = {
  'filetype',
  icons_enabled = true,
  icon = nil,
}

local branch = {
  'branch',
  icons_enabled = true,
  icon = '',
}

local location = {
  'location',
  padding = { 0, 6 },
}

local filename = {
  'filename',
  file_status = true,
  newfile_status = false,
  path = 1,
  shorting_target = 20,
  symbols = {
    modified = ' ●',
    readonly = ' ',
    unnamed = '[No Name]',
    newfile = '[New]',
  },
}

local diff = {
  'diff',
  source = diff_source,
  symbols = { added = ' ', modified = ' ', removed = ' ' },
}

local config = {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = '|',
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'alpha' },
      winbar = {
        'alpha',
        'neo-tree',
        'toggleterm',
        'packer',
      },
    },
    ignore_focus = {
      'neo-tree',
      'packer',
      'toggleterm',
      'TelescopePrompt',
      'null-ls-info',
    },
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { filename },
    lualine_b = {
      branch,
      diff,
      -- current_layout,
    },
    lualine_c = {
      { '%=', separator = '' },
      lsp_servers,
      formatters,
    },
    lualine_x = { 'encoding' },
    lualine_y = { filetype, 'fileformat' },
    lualine_z = { 'progress', location },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { 'neo-tree', 'toggleterm' },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
}

return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  lazy = false,
  config = function()
    local lualine = require('lualine')
    lualine.setup(config)
  end,
}
