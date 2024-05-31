local u = require("utils")

---Check if path exists in cwd
---@param path string
---@return boolean
local function is_exist_in_cwd(path)
  return vim.uv.fs_stat(vim.fs.joinpath(vim.uv.cwd(), path)) ~= nil
end

---Check if cwd contains config.eslint.js (new flat config)
---@return boolean
local function is_flat_config_in_cwd()
  return vim
    .iter({
      "eslint.config.js",
      "eslint.config.mjs",
      "eslint.config.cjs",
      "eslint.config.ts",
      "eslint.config.mts",
      "eslint.config.cts",
    })
    :any(is_exist_in_cwd)
end

---Check if cwd contains legacy config.
---@return boolean
local function is_legacy_config_in_cwd()
  return vim
    .iter({
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      ".eslintrc.json",
    })
    :any(is_exist_in_cwd)
end

---Check if flat config is used in cwd. If cwd contains legacy config, reuturned false. If not
---config detected, the 'ESLINT_USE_FLAT_CONFIG' value is used (for global config).
---@return boolean
local function is_use_flat_config()
  if is_legacy_config_in_cwd() then
    return false
  end
  return is_flat_config_in_cwd() or u.to_bool(vim.env.ESLINT_USE_FLAT_CONFIG)
end

return {
  settings = {
    experimental = {
      useFlatConfig = nil, -- Deprecated in this place. Deleted to avoid collisions
    },
    useFlatConfig = is_use_flat_config(),
  },
}
