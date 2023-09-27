---@module Foldtext
---Based on https://www.reddit.com/r/neovim/comments/16sqyjz/finally_we_can_have_highlighted_folds/
function HighlightedFoldtext()
  local pos = vim.v.foldstart
  local line = vim.api.nvim_buf_get_lines(0, pos - 1, pos, false)[1]
  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  -- If treesitter is not attached to the buffer
  if not ok then
    return vim.fn.foldtext()
  end

  local query = vim.treesitter.query.get(parser:lang(), 'highlights')

  if query == nil then
    return vim.fn.foldtext()
  end

  local tree = parser:parse({ pos - 1, pos })[1]
  local result = {}

  local line_pos = 0

  local prev_range = nil

  for id, node, _ in query:iter_captures(tree:root(), 0, pos - 1, pos) do
    local name = query.captures[id]
    local sr, sc, er, ec = node:range()

    if sr == pos - 1 and er == pos - 1 then
      local range = { sc, ec }

      -- Indent and whitespace
      if sc > line_pos then
        table.insert(result, { line:sub(line_pos + 1, sc), 'Folded' })
      end

      line_pos = ec
      local text = vim.treesitter.get_node_text(node, 0)

      if prev_range ~= nil and range[1] == prev_range[1] and range[2] == prev_range[2] then
        result[#result] = { text, '@' .. name }
      else
        table.insert(result, { text, '@' .. name })
      end

      prev_range = range
    end
  end

  table.insert(result, { ' { +' .. vim.v.foldend - vim.v.foldstart .. ' lines }', 'Folded' })

  return result
end

return 'luaeval("HighlightedFoldtext")()'
