local ts_utils = require('nvim-treesitter.ts_utils')
local M = {}

M.registry = {
  queue = {},
  current = nil,
}

M.need_clear = false

local function safety_update_selection(node)
  M.need_clear = false
  ts_utils.update_selection(0, node, 'v')
  M.need_clear = true
end

local function is_same_range(current, parent)
  local c_range = { current:range() }
  local p_range = { parent:range() }
  for i, n in ipairs(c_range) do
    if n ~= p_range[i] then
      return false
    end
  end
  return true
end

local function get_nearest_named()
  local node = ts_utils.get_node_at_cursor(0)
  if node then
    while not node:named() and node:child_count() > 0 do
      node = node:parent()
      if not node then
        break
      end
    end
  end
  return node
end

local function register_autoclean()
  vim.api.nvim_create_autocmd('ModeChanged', {
    once = true,
    callback = function()
      if not M.need_clear then
        M.clear_registry()
      end
    end,
  })
end

function M.expand_selection()
  if M.registry.current then
    local parent = M.registry.current:parent()
    while parent and is_same_range(M.registry.current, parent) do
      parent = parent:parent()
    end

    if not parent then
      return
    end

    table.insert(M.registry.queue, M.registry.current)
    M.registry.current = parent
  else
    M.registry.current = get_nearest_named()
    register_autoclean()
  end

  if M.registry.current then
    safety_update_selection(M.registry.current)
  end
end

function M.collapse_selection()
  if #M.registry.queue >= 1 then
    M.registry.current = table.remove(M.registry.queue, #M.registry.queue)
    M.need_clear = true
    ts_utils.update_selection(0, M.registry.current, 'v')
    M.need_clear = false
  elseif M.registry.current then
    local children = ts_utils.get_named_children(M.registry.current)
    for _, child in ipairs(children) do
      if child:child_count() ~= 0 then
        M.registry.current = child
        safety_update_selection(M.registry.current)
      end
    end
  end
end

function M.clear_registry()
  M.registry.queue = {}
  M.registry.current = nil
end

return M
