local listener_ls = vim.api.nvim_create_namespace('key_listener')

---Deleting hlsearch when it already no needed
local function toggle_hlsearch(char)
  local keys = { '<CR>', 'n', 'N', '*', '#', '?', '/' }
  local new_hlsearch = vim.tbl_contains(keys, char)

  if vim.opt.hlsearch:get() ~= new_hlsearch then
    vim.opt.hlsearch = new_hlsearch
  end
end

---Handler for pressing keys. Added listeners for modes
---@param char string
local function key_listener(char)
  local key = vim.fn.keytrans(char)
  local mode = vim.fn.mode()
  if mode == 'n' then
    toggle_hlsearch(key)
  end
end

vim.on_key(key_listener, listener_ls)
