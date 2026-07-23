vim.cmd [[hi clear]]
vim.g.colors_name = "meow"

require("base16-colorscheme").setup {
  base00 = "#f8f9fa", base01 = "#edeff1", base02 = "#d2d4d8", base03 = "#a0a6ac",
  base04 = "#8a9199", base05 = "#5c6166", base06 = "#4e5257", base07 = "#404447",
  base08 = "#e6193c", base09 = "#87711d", base0A = "#c99d2e", base0B = "#29a329",
  base0C = "#1999b3", base0D = "#3d62f5", base0E = "#ad2bee", base0F = "#38abaa",
}

vim.cmd [[
hi clear TSVariable
]]
