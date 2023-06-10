local function lsp_list()
  local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
  local buf_client_names = {}

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

local function set_hl()
  local statusline_hl = vim.api.nvim_get_hl(0, { name = 'StatusLine' })
  local string_hl = vim.api.nvim_get_hl(0, { name = 'String' })
  local special_hl = vim.api.nvim_get_hl(0, { name = 'SpecialKey' })
  local constant_hl = vim.api.nvim_get_hl(0, { name = 'Constant' })
  vim.api.nvim_set_hl(0, 'TSStatusActive', { bg = statusline_hl.bg, fg = string_hl.fg })
  vim.api.nvim_set_hl(0, 'LSPStatusActive', { bg = statusline_hl.bg, fg = special_hl.fg })
  vim.api.nvim_set_hl(0, 'FormatterStatusActive', { bg = statusline_hl.bg, fg = constant_hl.fg })
end

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  enable = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    set_hl()
    vim.api.nvim_create_autocmd('ColorScheme', {
      desc = 'Reload highlights when ColorScheme changed',
      callback = function()
        set_hl()
      end,
    })

    local progress = function()
      return string.format('%2d%%%%', math.floor(vim.fn.line('.') / vim.fn.line('$') * 100))
    end

    local treesitter = function()
      local highlighter = require('vim.treesitter.highlighter')
      local buf = vim.api.nvim_get_current_buf()
      return (highlighter.active[buf] and '%#TSStatusActive#%*' or '') .. ' TS'
    end

    local lsp = function()
      local lsp = lsp_list()
      local prefix = (lsp == '' and ' no lsp' or '%#LSPStatusActive#%*')
      return vim.trim(vim.fn.join({ prefix, lsp }, ' '))
    end

    local formatters = function()
      local formatters = formatters_list()
      local prefix = (formatters == '' and ' no formatters' or '%#FormatterStatusActive#%*')
      return vim.trim(vim.fn.join({ prefix, formatters }, ' '))
    end

    require('lualine').setup({
      options = {
        component_separators = {
          left = '|',
          right = '|',
        },
        section_separators = {
          left = ' ',
          right = ' ',
        },
      },
      sections = {
        lualine_a = {
          'mode',
        },
        lualine_b = { { 'branch', icon = '' } },
        lualine_c = {
          'filetype',
          { 'filename', file_status = false },
        },
        lualine_x = {
          'selectioncount',
          lsp,
          formatters,
          treesitter,
        },
        lualine_y = { progress },
        lualine_z = { 'location' },
      },
    })
  end,
}
