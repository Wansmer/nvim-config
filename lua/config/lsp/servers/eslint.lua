local u = require("utils")

---Check if path exists in cwd
---@param path string
---@return boolean
local function is_exist_in_cwd(path)
  return vim.uv.fs_stat(vim.fs.joinpath(vim.uv.cwd(), path)) ~= nil
end

---Check if cwd contains config.eslint.js (new flat config)
---@return boolean
local function is_cwd_use_flat_config()
  return is_exist_in_cwd("config.eslint.js")
end

---Check if flat config is used in cwd. Otherwise the 'ESLINT_USE_FLAT_CONFIG' value is used.
---If global config is used, make sure 'ESLINT_USE_FLAT_CONFIG' is set according  to the global
---config type.
---@return boolean
local function is_use_flat_config()
  return is_cwd_use_flat_config() or u.to_bool(vim.env.ESLINT_USE_FLAT_CONFIG)
end

return {
  settings = {
    experimental = {
      useFlatConfig = nil, -- Deprecated in this place. Deleted to avoid collisions
    },
    useFlatConfig = is_use_flat_config(),
  },
}
