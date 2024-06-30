--{{ Detect yaml.ansible
local function is_ansible_root()
  local ansible_root = { "ansible.cfg", ".ansible-lint.yml", "inventory.ini", "inventory.yml" }
  return vim.fs.root(vim.uv.cwd()--[[@as string]], ansible_root)
end

local function match_pattern(path)
  local patterns = { ".*/tasks/.*%.ya?ml", ".*/playbooks/.*%.ya?ml", ".*playbook.*%.ya?ml" }
  return vim.iter(patterns):any(function(pattern)
    return path:match(pattern)
  end)
end

local function ansible_or_yaml(path)
  return (is_ansible_root() or match_pattern(path)) and "yaml.ansible" or "yaml"
end

vim.filetype.add({
  extension = {
    ["yml"] = ansible_or_yaml,
    ["yaml"] = ansible_or_yaml,
  },
})
--}}

--{{ Detect env
vim.filetype.add({
  pattern = {
    [".*%.env%..*"] = "sh",
  },
})
--}}
