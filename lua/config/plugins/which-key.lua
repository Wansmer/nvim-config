return {
  'folke/which-key.nvim',
  enabled = true,
  dependencies = { 'langmapper' },
  config = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500

    local view = require('which-key.view')
    local ex = view.execute

    view.execute = function(prefix_i, mode, buf)
      local lmc = require('langmapper.config').config
      local en = lmc.layouts.ru.default_layout or lmc.default_layout
      local ru = lmc.layouts.ru.layout
      prefix_i = vim.fn.tr(prefix_i, ru, en)
      ex(prefix_i, mode, buf)
    end

    local lmu = require('langmapper.utils')
    local presets = require('which-key.plugins.presets')
    presets.operators = lmu.trans_dict(presets.operators)
    presets.objects = lmu.trans_dict(presets.objects)
    presets.motions = lmu.trans_dict(presets.motions)

    require('which-key').setup()
  end,
}
