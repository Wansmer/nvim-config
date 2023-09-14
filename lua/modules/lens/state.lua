---State - storage for extmark of symbol usage per buffer
---@class State
---@field state table
local State = {}
State.__index = State

function State.new()
  return setmetatable({ state = {} }, State)
end

---Add state for buffer
---@param key string
function State:add_buffer(key)
  if not self.state[key] then
    self.state[key] = {}
  end
end

---Get state of buffer
---@param key string
---@return table
function State:get_buffer(key)
  return self.state[key]
end

---Get record from buffer state
---@param state_id string
---@param record_id string
---@return table
function State:get_record(state_id, record_id)
  return self.state[state_id][record_id]
end

---Set record to buffer state
---@param state_id string
---@param record_id string
---@param data table
function State:set_record(state_id, record_id, data)
  self.state[state_id][record_id] = data
end

---Delete record from buffer storage
---@param state_id string
---@param record_id string
function State:del_record(state_id, record_id)
  print('TO DEL: ', record_id)
  self.state[state_id][record_id] = nil
end

return State.new()
