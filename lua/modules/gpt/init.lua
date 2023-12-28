-- NOT WORKING NOW: ai.fakeopen.com is not active

-- Knowleges and based on: https://github.com/CamdenClark/flyboy
local M = {}
M.__index = M

local gpt = require("modules.gpt.gpt").new()

function M:open()
  if not gpt then
    gpt = require("modules.gpt.gpt").new()
  end

  gpt:run()
end

return M
