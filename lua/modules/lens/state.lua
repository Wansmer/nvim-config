---State - storage for extmark of symbol usage per buffer
---@class State
---@field state table
local State = {}
State.__index = State

function State.new()
  return setmetatable({ state = {} }, State)
end

function State:add_buffer(key)
  if not self.state[key] then
    self.state[key] = {}
  end
end

function State:get_buffer(key)
  return self.state[key]
end

function State:get_record(state_id, record_id)
  return self.state[state_id][record_id]
end

function State:set_record(state_id, record_id, data)
  self.state[state_id][record_id] = data
end

function State:del_record(state_id, record_id)
  self.state[state_id][record_id] = nil
end

return State.new()
