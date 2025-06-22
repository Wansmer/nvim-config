local opts = require("modules.aider.opts")

local M = {}

local aider

--- Setup function to configure the Aider instance
--- @param user_opts? table Optional user configuration options. See `modules.aider.opts` for available options.
function M.setup(user_opts)
  opts.merge_opts(user_opts)

  -- Check if 'aider' executable is available
  if vim.fn.executable("aider") ~= 1 then
    vim.notify(
      "Aider executable not found. Please ensure 'aider' is installed and available in your system's PATH.",
      vim.log.levels.ERROR,
      { title = "Module: Aider" }
    )
    M.executable = false
    return
  end

  aider = require("modules.aider.aider")
end

function M.send_command(command)
  aider:send_command(command)
end

function M.open()
  aider:open()
end

function M.toggle()
  aider:toggle()
end

function M.add_file(bufnr)
  aider:add_file(bufnr)
end

function M.drop_file(filepath)
  aider:drop_file(filepath)
end

return M
