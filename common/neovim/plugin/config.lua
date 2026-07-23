vim.cmd.colorscheme "meow"

vim.opt.statusline  = "%!v:lua.require'ui'.statusline()"
vim.opt.tabline     = "%!v:lua.require'ui'.tabline()"
vim.opt.showtabline = 2
