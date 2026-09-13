local function set_ime(args)
    vim.g.neovide_input_ime = args.event:match("Enter$") and true or false
end

local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

vim.api.nvim_create_autocmd({"InsertEnter", "InsertLeave"}, {
    group = ime_input,
    pattern = "*",
    callback = set_ime
})

vim.api.nvim_create_autocmd({"CmdlineEnter", "CmdlineLeave"}, {
    group = ime_input,
    pattern = "[/\\?]",
    callback = set_ime
})

vim.g.neovide_input_ime = false

-- vim: sw=4:
