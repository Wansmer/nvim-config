local opts = require("modules.aider.opts")

local M = {}

--- Setup function to configure the Aider instance
--- @param user_opts? table Optional user configuration options. See `modules.aider.opts` for available options.
function M.setup(user_opts)
  opts.merge_opts(user_opts)
  M.__aider = require("modules.aider.aider")
end

function M.send_command(command)
  M.__aider:send_command(command)
end

function M.open()
  M.__aider:open()
end

function M.toggle()
  M.__aider:toggle()
end

function M.add_file(bufnr)
  M.__aider:add_file(bufnr)
end

function M.drop_file(filepath)
  M.__aider:drop_file(filepath)
end

function M.send_selected()
  M.__aider:send_selected()
end

-- TODO:
-- 1. /clear and /reset
-- 2. /commit (May be it should look like: - Aider give the commit message, User accept/deny it?)
-- 3. Provide mappings for
-- 3.1. /add file (current or via pattern)
-- 3.2. /read-only file (current or via pattern)
-- 3.3. /drop file (current or via pattern)
-- 4. Maybe using /ls to synchronize list of context files?
-- 5. List Aider commands via telescope
-- 6. Maybe open Aider in **separate** terminal split via kitty, not inside neovim?

return M
