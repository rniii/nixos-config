local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

vim.api.nvim_create_autocmd({"InsertEnter", "CmdlineEnter"}, {
    group = ime_input,
    pattern = "*",
    callback = function () vim.g.neovide_input_ime = true end
})

vim.api.nvim_create_autocmd({"InsertLeave", "CmdlineLeave"}, {
    group = ime_input,
    pattern = "[/\\?]",
    callback = function () vim.g.neovide_input_ime = false end
})

-- vim: sw=4:
