return {
  "nvzone/typr",
  dependencies = "nvzone/volt",
  cmd = { "Typr", "TyprStats" },
  config = function()
    require("typr").setup()
  end,
}
