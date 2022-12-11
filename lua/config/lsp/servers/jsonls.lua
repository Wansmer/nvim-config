local s_ok, schemastore = pcall(require, 'schemastore')

local settings = {
  json = {
    schemas = s_ok and schemastore.json.schemas() or {},
  },
}

return {
  settings = settings,
  setup = {},
}
