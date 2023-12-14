--[[ LSP dependent autocommands ]]

if vim.fn.has("nvim-0.10.0") == 1 then
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Enable inlayHint feature",
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.supports_method("textDocument/inlayHint", { bufnr = bufnr }) then
        vim.lsp.inlay_hint.enable(bufnr, PREF.lsp.show_inlay_hints)
      end
    end,
  })
end

-- {{ Toggle diagnostic dependent of insert mode
vim.api.nvim_create_autocmd("InsertEnter", {
  desc = "Hide diagnostic messages in insert mode",
  callback = function()
    vim.diagnostic.disable()
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  desc = "Show diagnostic messages in normal mode",
  callback = function()
    vim.diagnostic.enable()
  end,
})
-- }}
