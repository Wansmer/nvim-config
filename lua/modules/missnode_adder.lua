---Missing nodes adder
---USAGE EXAMPLE
---
---local missnode_adder = require('modules.missnode_adder')
---missnode_adder.setup({ --[[ settings ]] }) -- optional, work without setup with default
---vim.keymap.set('n', '<leader>ll', missnode_adder.insert_missing)
---
---vim.api.nvim_create_autocmd('FileType', {
---  pattern = missnode_adder.get_langs(),
---  callback = function()
---    vim.api.nvim_create_autocmd('ModeChanged', {
---      pattern = 'i:n',
---      callback = missnode_adder.insert_missing,
---    })
---  end,
---})

local M = {} -- module API
local H = {} -- helpers
local MissNodeAdder = {} -- functional
MissNodeAdder.__index = MissNodeAdder

local DEFAULT_OPTS = {
  langs = {
    rust = {
      missing_to_insert = {
        [';'] = {
          ---To decide whether to insert missing text or not, it is possible to check the node (sibling, parent, etc.).
          ---@type boolean|fun(node: TSNode): boolean
          enable = true,
          ---Text to insert. Needed when the type of the lost node is different from the text to be inserted.
          ---Can be a function that builds text (e.g., context-dependent).
          ---@type string|fun(node: TSNode): string
          text = ';',
        },
      },
    },
  },
}

M.opts = DEFAULT_OPTS

local function _handle_node(opts, node)
  opts = opts.missing_to_insert[node:type()]
  local need_handle = opts and (type(opts.enable) == 'boolean' and opts.enable or opts.enable(node))

  if need_handle then
    local sr, sc, er, ec = node:range()
    local text = type(opts.text) == 'string' and opts.text or opts.text(node)
    vim.api.nvim_buf_set_text(0, sr, sc, er, ec, { text })
  end
end

function MissNodeAdder.new(lang, opts, root)
  return setmetatable({ root = root, opts = opts, lang = lang }, MissNodeAdder)
end

function MissNodeAdder:handle_tree()
  H.walk_tree(self.root, H.is_missing, H.bind(_handle_node, self.opts))
end

-- API
function M.get_langs()
  return vim.tbl_keys(M.opts.langs)
end

function M.insert_missing()
  local lang = vim.api.nvim_buf_get_option(0, 'ft')
  local opts = M.opts.langs[lang]

  if not opts then
    return
  end

  local ok_p, parser = pcall(vim.treesitter.get_parser, 0, lang)
  if not ok_p then
    return
  end

  local tree = parser:trees()[1]
  local formatter = MissNodeAdder.new(lang, opts, tree:root())

  formatter:handle_tree()
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend('force', M.opts, opts or {})
end

-- HELPERS
function H.bind(fn, first)
  return function(...)
    return fn(first, ...)
  end
end

function H.is_missing(node)
  return node:missing()
end

function H.walk_tree(node, fn_cond, handler)
  if fn_cond(node) then
    handler(node)
  end

  for child in node:iter_children() do
    H.walk_tree(child, fn_cond, handler)
  end
end

return M
