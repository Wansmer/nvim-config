--{{ Detect yaml.ansible
local function ansible_or_yaml()
  local ansible_root = { "ansible.cfg", ".ansible-lint.yml", "inventory.ini", "inventory.yml" }
  return vim.fs.root(vim.env.PWD, ansible_root) and "yaml.ansible" or "yaml"
end

vim.filetype.add({
  pattern = {
    [".*/tasks/.*.ya?ml"] = "yaml.ansible",
    [".*/playbooks/.*.ya?ml"] = "yaml.ansible",
    ["*playbook*.ya?ml"] = "yaml.ansible",
  },
  extension = {
    ["yml"] = ansible_or_yaml,
    ["yaml"] = ansible_or_yaml,
  },
})
--}}
