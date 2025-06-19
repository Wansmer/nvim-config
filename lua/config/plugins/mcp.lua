return {
  "ravitemer/mcphub.nvim",
  build = "npm install -g mcp-hub@latest",
  config = function()
    require("mcphub").setup()
  end,
}
