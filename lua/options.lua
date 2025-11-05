local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- globals ------------------------------------------
g.vimwiki_list = {
  {
    path = '~/Documents/vimwiki',
    ext = '.md',
    syntax = 'markdown',
  },
}

-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
opt.backup = false
opt.writebackup = false
opt.termguicolors = true

-- pressing 'gw' aligns text to textwidth and remove auto-wrap.
-- see :h formatoptions
opt.textwidth = 100
-- NOTE: something overrides this. maybe it's for markdown only? if
-- this happens in another language, then figure this out.
-- opt.formatoptions:remove("t")

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- Folding - https://neovim.io/doc/user/fold.html
vim.wo.foldmethod = "indent"
-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Unfolded by default
vim.wo.foldlevel = 99

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
