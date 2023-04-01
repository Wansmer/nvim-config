local u = require('utils')

local route_cmd = {
  mes = {
    abort = { 'clear' },
    title = 'What’s this :mess my config just created',
  },
  ls = {
    abort = false,
    title = "These aren't the :buffers you're looking for",
  },
  buffers = {
    abort = false,
    title = "These aren't the :buffers you're looking for",
  },
  files = {
    abort = false,
    title = "These aren't the :buffers you're looking for",
  },
  ['lua='] = {
    title = 'Outro lado da :lua',
    abort = false,
  },
}

local function open_split(cmd, title)
  local result = vim.split(vim.fn.execute(cmd), '\n')
  result = vim.tbl_filter(function(line)
    return line ~= ''
  end, result)

  local height = #result >= 30 and 30 or #result
  title = #result == 0 and 'Wow! So clean!' or title

  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = vim.opt.columns:get(),
    height = height <= 5 and 5 or height,
    col = 0,
    row = vim.opt.lines:get(),
    style = 'minimal',
    border = 'solid',
    title = title,
    title_pos = 'left',
    noautocmd = true,
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, true, result)
  vim.cmd.norm('G')
  vim.keymap.set('n', 'q', '<Cmd>bw!<Cr>', { buffer = buf })
end

local function need_route(cmd)
  local start, end_ = cmd:find('^%d+')
  local cleared = vim.trim(cmd)
  local has, need, data

  if start and end_ then
    cleared = vim.trim(cmd:sub(end_ + 1))
  end

  local commands = vim.tbl_keys(route_cmd)
  local key = ''

  has = u.some(commands, function(el)
    local found = vim.startswith(cleared, el)
    if found then
      key = el
    end
    return found
  end)

  if has then
    data = route_cmd[key]
    if data.abort then
      need = not u.some(data.abort, function(el)
        return cleared:match(el)
      end)
    else
      need = true
    end
  end

  return (has and need), data
end

vim.api.nvim_create_autocmd('CmdlineLeave', {
  callback = function()
    local event = vim.v.event
    if not event.abort and event.cmdtype == ':' then
      local cmd = vim.fn.getcmdline()
      local need, data = need_route(cmd)
      if need then
        vim.fn.setcmdline(cmd) -- to save history
        u.feedkeys('<Esc>') -- abort current cmd
        open_split(cmd, data.title) -- execute cmd and redirect to new window
      end
    end
  end,
})
