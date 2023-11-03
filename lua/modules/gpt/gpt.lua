local u = require('utils')
local api = require('modules.gpt.api')

local USER = { '', '# User:' }
local ASSISTANT = { '', '# Assistant:' }

local GPT = {}
GPT.__index = GPT

function GPT.new(opts)
  return setmetatable({
    opts = opts,
    messages = {},
    layout = nil,
  }, GPT)
end

function GPT:run()
  self:open_win()
end

local function is_valid_response(response)
  return response
    and response.choices
    and response.choices[1]
    and response.choices[1].delta
    and response.choices[1].delta.content
end

function GPT:send_request()
  if not self.layout then
    self:open_win()
  end

  local res_buf = self.layout.result.buf
  local prompt_buf = self.layout.prompt.buf
  local count = vim.api.nvim_buf_line_count(res_buf)

  local request = vim.api.nvim_buf_get_lines(prompt_buf, 0, -1, false)
  self:add_message({ role = 'user', content = vim.fn.join(request, '\n') })
  vim.api.nvim_buf_set_lines(res_buf, count, count, false, u.concat(USER, request, ASSISTANT, { '...' }))
  local cur_line = vim.api.nvim_buf_line_count(res_buf)

  local content = ''
  local answer = { role = 'assistant', content = '' }

  local on_delta = function(response)
    if not is_valid_response(response) then
      return
    end

    local delta = response.choices[1].delta.content
    answer.content = answer.content .. delta

    if delta == '\n' then
      vim.api.nvim_buf_set_lines(res_buf, cur_line, cur_line + 1, false, { '' })
    elseif delta:match('\n') then
      for line in delta:gmatch('[^\n]+') do
        vim.api.nvim_buf_set_lines(res_buf, cur_line, cur_line + 1, false, { content .. line })
        cur_line = cur_line + 1
        content = ''
      end
    else
      content = content .. delta
    end
  end

  local on_complete = function()
    vim.api.nvim_buf_set_lines(res_buf, cur_line, cur_line + 1, false, { content })
    self:add_message(answer)
    vim.api.nvim_buf_set_lines(prompt_buf, 0, -1, false, {})
  end

  api.fetch(self.messages, on_delta, on_complete)
end

function GPT:open_win()
  self.layout = require('modules.gpt.ui').get_layout()
  self:set_keymaps()
  self:print_messages()
end

function GPT:print_messages()
  local buf = self.layout.result.buf
  local count = vim.api.nvim_buf_line_count(buf) + 1
  for _, message in ipairs(self.messages) do
    if message.role == 'user' then
      vim.api.nvim_buf_set_lines(buf, count, count, false, u.concat(USER, vim.split(message.content, '\n')))
    else
      vim.api.nvim_buf_set_lines(buf, count, count, false, u.concat(ASSISTANT, vim.split(message.content, '\n')))
    end
    count = vim.api.nvim_buf_line_count(buf) + 1
  end
end

function GPT:set_keymaps()
  local layout = self.layout
  local close = function()
    vim.api.nvim_buf_delete(layout.result.buf, { force = true })
    vim.api.nvim_buf_delete(layout.prompt.buf, { force = true })
  end

  vim.keymap.set('n', 'q', close, { buffer = layout.prompt.buf })
  vim.keymap.set({ 'n', 'i' }, "<C-'>", close, { buffer = layout.prompt.buf })
  vim.keymap.set('i', '<C-c>', close, { buffer = layout.prompt.buf })
  vim.keymap.set('n', 'q', close, { buffer = layout.result.buf })
  vim.keymap.set({ 'n', 'i' }, "<C-'>", close, { buffer = layout.result.buf })
  vim.keymap.set('i', '<C-c>', close, { buffer = layout.result.buf })

  vim.keymap.set('n', '<CR>', function()
    self:send_request()
  end, { buffer = layout.prompt.buf })
end

---Add message to messages
---@param message {role: string, content: string}
function GPT:add_message(message)
  table.insert(self.messages, message)
end

return GPT
