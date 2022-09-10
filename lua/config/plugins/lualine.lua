local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then
  return
end

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
  padding = { 0, 2 },
}

local config = {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = '|',
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = { 'alpha' },
      winbar = { 'alpha', 'neo-tree', 'toggleterm', 'packer' },
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
    lualine_a = { 'filename', 'filesize' },
    lualine_b = { branch },
    lualine_c = { { '%=', separator = '' }, lsp_servers, formatters },
    lualine_x = { 'encoding' },
    lualine_y = { filetype, 'fileformat' },
    lualine_z = { location },
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

lualine.setup(config)
