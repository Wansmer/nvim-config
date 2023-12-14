local curl = require("plenary.curl")

local M = {}

function M.fetch(messages, on_delta, on_complete)
  local url = "https://ai.fakeopen.com/v1/chat/completions"

  local headers = {
    Authorization = "Bearer pk-this-is-a-real-free-pool-token-for-everyone",
    Content_Type = "application/json",
  }

  curl.post(url, {
    headers = headers,
    body = vim.fn.json_encode({
      model = "gpt-3.5-turbo",
      temperature = 1,
      messages = messages,
      stream = true,
    }),
    stream = vim.schedule_wrap(function(err, data, _)
      if err or vim.startswith(data, "error:") then
        error(data or err)
      end

      local raw_message = string.gsub(data, "^data: ", "")

      if raw_message == "[DONE]" then
        on_complete()
      elseif string.len(data) > 6 then
        on_delta(vim.fn.json_decode(string.sub(data, 6)))
      end
    end),
  })
end

return M
