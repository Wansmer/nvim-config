local present, schemas = pcall(require, 'schemastore')
if not present then
  return
end

local settings = {
  json = {
    schemas = schemas.json.schemas(),
  },
}

local setup = {
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
      end,
    },
  },
}

return {
  settings = settings,
  setup,
}
