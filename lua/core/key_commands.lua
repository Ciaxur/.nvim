
local M = {}

M.general = {
  -- ":W" -> sudo saves current file
  ["-nargs=0 W"] = "execute 'w !sudo tee % > /dev/null'",

  -- ":FoldAll"
  ["-nargs=0 FoldAll"] = "normal! zM<CR>",

  -- ":UnFoldAll"
  ["-nargs=0 UnFoldAll"] = "normal! zR<CR>",

  -- Splits current line into N lines based on the "textwidth" value.
  ["-nargs=0 SplitLineTextWidth"] = "normal! gqap<CR>",

  -- Prints all the session environment variables
  ["-nargs=0 PrintEnvs"] = "execute 'lua for k, v in pairs(vim.fn.environ()) do print(k .. \"=\" .. v) end'",

  -- Copies the current open buffer's full path to clipboard
  ["-nargs=0 CopyFileAbsPath"] = "normal! :let @+ = expand(\"%:p\")<CR>",

  -- Copies the current open buffer's relative path to clipboard
  ["-nargs=0 CopyFileRelPath"] = "normal! :let @+ = expand(\"%:.\")<CR>",
}

return M
