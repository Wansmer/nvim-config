vim.loader.enable()

vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = '['

require('user_settings')
require('options')
require('plugins')
require('config.colorscheme')
require('mappings')
require('autocmd')
require('modules.thincc')
require('modules.git_watcher')

vim.keymap.set('n', '<leader>ff', function()
  require('modules.gpt').open()
end, { desc = 'GPT' })

-- curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer pk-this-is-a-real-free-pool-token-for-everyone" -d '{
--         "frequency_penalty": 0,
--         "messages": [
--                 {
--                         "content": "Tell some joke",
--                         "role": "user"
--                 }
--         ],
--         "model": "gpt-3.5-turbo",
--         "presence_penalty": 0,
--         "stream": true,
--         "temperature": 1,
--         "top_p": 1
--  }' https://ai.fakeopen.com/v1/chat/completions

-- https://platform.openai.com/docs/api-reference/chat/create
-- local API = 'https://ai.fakeopen.com/v1/chat/completions'
-- local TOKEN = 'pk-this-is-a-real-free-pool-token-for-everyone'
--
-- local body = vim.json.encode({
--   frequency_penalty = 0,
--   messages = {
--     {
--       content = 'Write program on JS min on 20 lines of code',
--       role = 'user',
--     },
--   },
--   model = 'gpt-3.5-turbo',
--   presence_penalty = 0,
--   stream = true,
--   temperature = 1,
--   top_p = 1,
-- })
--
-- local cmd = {
--   'curl',
--   '-X',
--   'POST',
--   '-H',
--   'Content-Type: application/json',
--   '-H',
--   'Authorization: Bearer ' .. TOKEN,
--   '-d',
--   body,
--   API,
-- }
--
-- local count = 0
--
-- vim.system(cmd, {
--   stdout = vim.schedule_wrap(function(err, data)
--     if err then
--       error(err)
--     end
--
--     count = count + 1
--     if data then
--       data = string.gsub(data, '^data: ', '')
--       local ok, res = pcall(vim.fn.json_decode, data)
--       print('Count:', count, 'Data:', data, 'OK?', ok, 'Res:', res)
--       -- {"id":"chatcmpl-OktUqRCfcFQl2A1zZ63dIBbnpCfSm","object":"chat.completion","created":1698528427,"model":"gpt-3.5-turbo","usage":{"prompt_tokens":0,"completion_tokens":0,"total_tokens":0},"choices":[{"message":{"role":"assistant","content":"Sure, here's a classic one for you:\n\nWhy don't scientists trust atoms?\n\nBecause they make up everything!"},"finish_reason":"stop","index":0}]}
--       -- data = vim.json.decode(data)
--       -- local mes = data.choices[1].message.content
--     end
--   end),
-- })
