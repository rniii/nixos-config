local severity = vim.diagnostic.severity

-- local function buflist()
--   local current
--   local list = {}
--   local cbuf = vim.fn.bufnr()

--   for i = 1, vim.fn.bufnr("$") do
--     if vim.fn.buflisted(i) == 1 then
--       if i == cbuf then current = #list + 1 end

--       list[#list + 1] = i
--     end
--   end

--   return list, current
-- end

local function hl(text, group)
  return (group and "%#" .. group .. "#" or "%*") .. text
end

local function strwidth(text)
  return vim.api.nvim_strwidth(text)
end

local function truncate(text, len)
  while strwidth(text) > len - 1 do
    text = vim.fn.slice(text, 0, -1)
  end

  return text .. string.rep(" ", len - strwidth(text) - 1) .. "…"
end

--- Main exports ------------------------------------------

local M = {}

function M.statusline()
  return " %{%v:lua.require'ui'.status_bufname()%}"
      .. " %{%v:lua.require'ui'.status_diagnostic()%}"
      .. " %{%v:lua.require'ui'.status_diffstatus()%}"
      .. "%="
      .. hl("%-14.(%l,%c%V%) %P")
end

function M.tabline(bufnr)
  return ""
end

function M.winbar()
  return ""
end

--- Statusline components ---------------------------------

function M.status_bufname()
  local icon, icon_hl = MiniIcons.get("filetype", vim.bo.filetype)

  return hl(icon .. " ", icon_hl) .. hl("%f") .. hl("%h%w%m%r", "NonText")
end

function M.status_diagnostic()
  local text = ""
  local diagnostics = vim.diagnostic.count(0)

  if diagnostics[severity.ERROR] then
    text = text
      .. hl(" ", "DiagnosticError")
      .. hl(diagnostics[severity.ERROR])
  end

  if diagnostics[severity.WARN] then
    text = text
      .. hl(" ", "DiagnosticWarn")
      .. hl(diagnostics[severity.WARN])
  end

  return text
end

function M.status_diffstatus()
  local status = vim.b.gitsigns_status_dict or {}
  local text = ""

  if status.added and status.changed and status.removed then
    text = text
      .. hl("+" .. status.added,   "Added")   .. " "
      .. hl("~" .. status.changed, "Changed") .. " "
      .. hl("-" .. status.removed, "Removed")
  end

  return text
end

return M
