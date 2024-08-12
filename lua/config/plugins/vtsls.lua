return {
  "yioneko/nvim-vtsls",
  enabled = true,
  event = "LspAttach",
  config = function()
    require("vtsls").config({})
  end,
}
