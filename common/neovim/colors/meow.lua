vim.g.colors_name = "meow"
vim.o.termguicolors = true

local palette

if vim.o.background == "light" then
  palette = {
    bg00 = "#fdf9fe", fg00 = "#958296",
    bg01 = "#ede8f4", fg01 = "#573e59",
    bg02 = "#d7d9e8", fg02 = "#40344f",

    constant  = "#ea46c4",
    error     = "#d1301b",
    warning   = "#edb828",
    string    = "#3fcc46",
    operator  = "#43c8e0",
    method    = "#6a87fc",
    keyword   = "#bc38bc",

    color10 = "#ff8080",
    color11 = "#ffa880",
    color12 = "#ffff80",
    color13 = "#80ff80",
    color14 = "#80ffff",
  }
else
  palette = {
    bg00 = "#1e191e", fg00 = "#8b7c8c",
    bg01 = "#282128", fg01 = "#e4dced",
    bg02 = "#3f383f", fg02 = "#f7edf7",

    constant  = "#ee95d2",
    error     = "#ee9598",
    warning   = "#e8d097",
    string    = "#9be099",
    operator  = "#97d0e8",
    method    = "#979ae8",
    keyword   = "#ca97e8",

    color10 = "#ff8080",
    color11 = "#ffa880",
    color12 = "#ffff80",
    color13 = "#80ff80",
    color14 = "#80ffff",
  }
end

local function hi(name, val)
  vim.api.nvim_set_hl(0, name, val)
end

vim.cmd [[hi clear]]

hi("Normal",      { fg = palette.fg01, bg = palette.bg00 })
hi("Cursor",      { fg = palette.bg00, bg = palette.fg00 })
hi("NonText",     { fg = palette.fg00 })
hi("LineNr",      { link = "NonText" })
hi("Folded",      { link = "NonText" })
hi("SignColumn",  { link = "NonText" })
hi("Conceal",     { link = "NonText" })
hi("Title",       { fg = palette.fg01, bold = true })

hi("CursorLine",      { bg = palette.bg01 })
hi("CursorLineNr",    { bg = palette.bg01, bold = true })
hi("CursorLineSign",  { bg = palette.bg01, fg = palette.fg00 })
hi("CursorColumn",    { link = "CursorLine" })
hi("ColorColumn",     { link = "CursorLine" })
hi("Visual",          { bg = palette.bg02 })
hi("StatusLine",      { fg = palette.fg02, bg = palette.bg01 })
hi("StatusLineNC",    { fg = palette.fg00, bg = palette.bg02 })
hi("Pmenu",           { bg = palette.bg01 })
hi("PmenuSel",        { bg = palette.bg02 })
hi("TabLine",         { bg = palette.bg01 })
hi("TabLineSel",      { bg = palette.bg00, bold = true })
hi("WinBar",          { link = "TabLineSel" })
hi("WinBarNC",        { link = "TabLineSel" })

hi("Constant",      { fg = palette.constant })
hi("ErrorMsg",      { fg = palette.error })
hi("WarningMsg",    { fg = palette.warning })
hi("String",        { fg = palette.string })
hi("Operator",      { fg = palette.operator })
hi("Function",      { fg = palette.method })
hi("Statement",     { fg = palette.keyword, bold = true })
hi("Delimiter",     { fg = palette.fg00 })
hi("Comment",       { fg = palette.fg00, italic = true })
hi("Type",          { })
hi("Identifier",    { })

hi("Special",       { link = "Operator" })
hi("Added",         { link = "String" })
hi("Changed",       { link = "Operator" })
hi("Removed",       { link = "ErrorMsg" })
hi("Directory",     { link = "Operator" })
hi("OkMsg",         { link = "String" })
hi("MoreMsg",       { link = "Operator" })
hi("ModeMsg",       { link = "String" })
hi("Question",      { link = "Operator" })
hi("QuickFixLine",  { link = "Operator" })

hi("@variable",           { })
hi("@variable.member",    { })
hi("@lsp.type.property",  { })

hi("SpellBad",      { sp = palette.error, undercurl = true })
hi("SpellCap",      { sp = palette.warning, undercurl = true })
hi("SpellRare",     { sp = palette.operator, undercurl = true })
hi("SpellLocal",    { sp = palette.string, undercurl = true })

hi("Search",        { bg = palette.color11 })
hi("CurSearch",     { bg = palette.color12 })
hi("DiffAdd",       { bg = palette.color13 })
hi("DiffChange",    { bg = palette.color14 })
hi("DiffDelete",    { bg = palette.color10 })
hi("DiffText",      { bg = palette.color11 })

hi("BlinkCmpLabelMatch", { fg = palette.method, bold = true })
hi("IlluminatedWordText", { sp = palette.fg00, underline = true })
hi("IlluminatedWordRead", { sp = palette.fg00, underline = true })
hi("IlluminatedWordWrite", { sp = palette.fg00, underline = true })
