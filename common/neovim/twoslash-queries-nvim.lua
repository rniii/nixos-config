vim.lsp.config("ts_ls", { on_attach = function(client, bufnr)
  require("twoslash-queries").attach(client, bufnr)
end })
