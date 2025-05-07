-- WIP
local M = {}
M.__index = M

function M.start()
  if not M:is_devcontainer_repo() then
    return
  end

  vim.api.nvim_create_user_command("DevContainer", function(args)
    if args.args == "start" then
      local dc = setmetatable({
        status = "starting",
        workspace_folder = vim.uv.cwd(),
        log_file = vim.fn.stdpath("cache") .. "/devcontainer.log",
      }, M)

      dc:setup()

      -- TODO: add 'stop', 'attach', `command`, `exec`, etc
    end
  end, { nargs = 1 })

  vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
      vim.notify(
        "Folder contains a Dev Container configuration file. Run `:DevContainer start` to develop in a container",
        vim.log.levels.INFO,
        { title = "DevContainer" }
      )
    end,
  })
end

function M:is_devcontainer_repo()
  return vim.uv.fs_stat(".devcontainer/devcontainer.json") ~= nil
end

function M:setup()
  self:read_cfg()
  self:up()
  self:setup_listener()
end

function M:read_cfg()
  vim.system(
    { "devcontainer", "read-configuration", "--workspace-folder", self.workspace_folder },
    { text = true },
    function(res)
      if res.code ~= 0 then
        -- TODO: use logger
        print("Error to read devcontainer configuration:", res.stderr)
        self.status = "error"
        return
      end

      self.cfg = vim.json.decode(res.stdout)
      if self.cfg == nil then
        print("Error to decode devcontainer configuration:", res.stderr)
        return
      end
    end
  )
end

function M:up()
  return vim.system(
    { "devcontainer", "up", "--workspace-folder", self.workspace_folder },
    { text = true },
    function(res)
      if res.code ~= 0 then
        print("Error to start devcontainer:", res.stderr)
        self.status = "error"
        return
      end

      vim.print(res.stdout)

      local container_info = vim.json.decode(res.stdout)
      if container_info == nil then
        print("Error to decode devcontainer info:", res.stderr)
      end

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("User", { pattern = "DevContainerStarted" })
      end)

      self.container_info = container_info
      self.status = "running"
    end
  )
end

function M:setup_listener()
  vim.api.nvim_create_autocmd("User", {
    pattern = "DevContainerStarted",
    callback = function()
      vim.api.nvim_create_autocmd("TermOpen", {
        callback = function(e)
          local pid = e.match:match("(%d+):/bin/zsh")
          if pid then
            local chan = vim.iter(vim.api.nvim_list_chans()):find(function(c)
              local ok, pid_by_chan = pcall(vim.fn.jobpid, c.id)
              return c.mode == "terminal" and ok and pid_by_chan == tonumber(pid)
            end)

            local cmd = ("docker exec -w %s -it %s /bin/zsh\n\x0c"):format(
              self.container_info.remoteWorkspaceFolder,
              self.container_info.containerId
            )

            vim.schedule(function()
              vim.api.nvim_chan_send(chan.id, cmd)
            end)
          end
        end,
      })
    end,
  })
end

-- Write log to file in cache directory
function M:log()
  return vim.system(
    { "devcontainer", "logs", "--workspace-folder", self.workspace_folder, "--log-file", self.log_file },
    { text = true }
  )
end

return M
