vim.api.nvim_create_autocmd("FileType", { pattern = "*", callback = function()
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)

  if vim.treesitter.query.get(lang, "highlights") then
    vim.treesitter.start()
    if vim.treesitter.query.get(lang, "indents") then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end
end })
