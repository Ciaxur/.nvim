local map = vim.keymap.set

----------------------------------------- General -----------------------------------------
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })

map("n", "<A-o>", "<cmd>ClangdSwitchSourceHeader<CR>", { desc = "opens .h/.cc related file" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-Left>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-Right>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-Down>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-Up>", "<C-w>k", { desc = "switch window up" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

map("n", "<leader>?", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

-- Manipulate split windows
map("n", "<leader>z", "<cmd> ToggleMaximize <CR>", { desc = "toggle maximizing the active window" })
map("n", "<leader>\\", "<cmd> vsplit <CR>", { desc = "vertically split current window" })
map("n", "<leader>-", "<cmd> split <CR>", { desc = "horizontally split current window" })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
map({ "n", "x" }, "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "move down", expr = true })
map({ "n", "x" }, "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "move up", expr = true })
map("n", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "move up", expr = true })
map("n", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "move down", expr = true })


-- Buffer menu
map("n", "<leader>bn", "<cmd> enew <CR>", { desc = "new buffer" })

map("n", "<leader>ba", function()
  require("nvchad.tabufline").closeAllBufs(false)
end, { desc = "close all but current buffer" })

map("n", "<leader>br", function()
  require("nvchad.tabufline").move_buf(1)
end, { desc = "moves current tab right" })

map("n", "<leader>bl", function()
  require("nvchad.tabufline").move_buf(-1)
end, { desc = "moves current tab left" })


-- Indentation
map("v", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = "move up", expr = true });
map("v", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = "move down", expr = true });
map("v", "<", "<gv", { desc = "dedent line" });
map("v", ">", ">gv", { desc = "indent line" });


-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })


-- Formatting
map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

map("v", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format highlighted block" })



----------------------------------------- tabufline -----------------------------------------
map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })


-- Alt+N where N is a number key. Goes to the tab buffer with respect to the number key.
local go_to_buffer_index = function(buf_index)
  local bufs     = vim.t.bufs;
  local bufs_len = #bufs;
  local set_buf  = vim.api.nvim_set_current_buf;

  if bufs_len >= buf_index then
    set_buf(bufs[buf_index])
  end
end

for i = 1, 9, 1 do
  local cmd = "<A-" .. i .. ">";
  local description = "switch to buffer " .. i;
  map("n", cmd, function()
    go_to_buffer_index(i);
  end, { desc = description });
end



----------------------------------------- NeoGit -----------------------------------------
map("n", "<leader>gv", "<cmd>Neogit<CR>", { desc = "opens neogit view" })





----------------------------------------- lspconfig -----------------------------------------
map("n", "K", function()
  vim.lsp.buf.hover({
    border = "rounded",
  });
end, { desc = "LSP hover" })

map("n", "<leader>lgf", function()
  vim.diagnostic.open_float({ border = "rounded " })
end, { desc = "LSP floating signature help" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = 1, float = { border = "rounded" } })
end, { desc = "LSP diagnostics go to previous" })

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = { border = "rounded" } })
end, { desc = "LSP diagnostics go to previous" })


-- lsp menu
-- NOTE: replaced with Glance
map("n", "<leader>lm", vim.diagnostic.setloclist, { desc = "LSP diagnostic show location list" })
-- map("n", "<leader>ld", function()
--   vim.lsp.buf.declaration()
-- end, { desc = "LSP declaration" })
--
-- map("n", "<leader>li", function()
--   vim.lsp.buf.implementation()
-- end, { desc = "LSP implementation" })

map("n", "<leader>ls", function()
  vim.lsp.buf.signature_help()
end, { desc = "LSP signature help" })


-- code menu
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cr", require "nvchad.lsp.renamer", { desc = "LSP NvRenamer" })


----------------------------------------- nvimtree -----------------------------------------
map("n", "<A-E>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })



----------------------------------------- telescope -----------------------------------------
map("n", "<C-p>", "<cmd> Telescope find_files <CR>", { desc = "telescope find files" })

-- telescope search menu
map("n", "<leader>rg", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })

-- telescope finder menu
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>fs", function ()
  -- see :h telescope.builtin.lsp_document_symbols
  local telescope_builtin = require("telescope.builtin");
  telescope_builtin.lsp_document_symbols({
    fname_width = 40,
    symbol_width = 40,
    symbol_type_width = 20,
  });
end, { desc = "telescope find symbols current buffer" })

map("n", "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files (no ignore & hidden files)" }
)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })

-- telescope menu
map({ "n", "v" }, "<leader>tt", "<cmd>Telescope<CR>", { desc = "telescope menu" })
map("n", "<leader>ts", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>",
  { desc = "telescope dynamic workspace symbols" })

map("n", "<leader>ta", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>tc", "<cmd>Telescope commands<CR>", { desc = "telescope commands" })

map("n", "<leader>th", function()
  require("nvchad.themes").open()
end, { desc = "telescope nvchad themes" })

-- telescope git menu
map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })

-- telescope picker menu
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })


----------------------------------------- Tabular -----------------------------------------
map("v", "<leader>ft", '<cmd>Tabular /=<cr>', { desc = "tabular format aligns selection on equals character" })



----------------------------------------- NvTerm -----------------------------------------
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- toggleable terminal
map({ "n", "t" }, "<A-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

map({ "n", "t" }, "<A-v>", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
end, { desc = "terminal toggleable horizontal term" })


-- new terminal
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical term" })



----------------------------------------- whichkey -----------------------------------------
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })



----------------------------------------- gitsigns -----------------------------------------
map("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  vim.schedule(function()
    package.loaded.gitsigns.next_hunk()
  end)
  return "<Ignore>"
end, { desc = "gitsigns jump to next hunk", expr = true })

map("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  vim.schedule(function()
    package.loaded.gitsigns.prev_hunk()
  end)
  return "<Ignore>"
end, { desc = "gitsigns jump to prev hunk", expr = true })

-- gitsigns git menu
map("n", "<leader>gb", function()
  package.loaded.gitsigns.blame()
end, { desc = "gitsigns show blame line menu" })
map("n", "<leader>gd", function()
  package.loaded.gitsigns.toggle_deleted()
end, { desc = "gitsigns toggle deleted lines" })
map("n", "<leader>gu", function()
  package.loaded.gitsigns.undo_stage_hunk()
end, { desc = "gitsigns undo last staged hunk" })

map("v", "<leader>gs", function()
  local line0 = vim.fn.getpos("v")[2];
  local line1 = vim.fn.getcurpos()[2];
  local selection_range = { line0, line1 };

  vim.schedule(function()
    package.loaded.gitsigns.stage_hunk(selection_range);
  end)
end, { desc = "gitsigns stage currently selected block" })

map("v", "<leader>gr", function()
  local line0 = vim.fn.getpos("v")[2];
  local line1 = vim.fn.getcurpos()[2];
  local selection_range = { line0, line1 };

  vim.schedule(function()
    package.loaded.gitsigns.reset_hunk(selection_range);
  end)
end, { desc = "gitsigns resets currently selected block" })

-- gitsigns hunk menu
map("n", "<leader>ghr", function()
  package.loaded.gitsigns.reset_hunk()
end, { desc = "gitsigns reset hunk" })
map("n", "<leader>ghp", function()
  package.loaded.gitsigns.preview_hunk()
end, { desc = "gitsigns preview hunk" })


----------------------------------------- Glance -----------------------------------------
map("n", "<leader>lr", "<cmd>Glance references<CR>", { desc = "glance opens references preview" })
map("n", "<leader>ld", "<cmd>Glance definitions<CR>", { desc = "glance opens definitions preview" })
map("n", "<leader>lT", "<cmd>Glance type_definitions<CR>", { desc = "glance opens type definitions preview" })
map("n", "<leader>li", "<cmd>Glance implementations<CR>", { desc = "glance opens implementations preview" })


----------------------------------------- trouble -----------------------------------------
map("n", "<leader>lm", "<cmd>Trouble diagnostics<CR>", { desc = "trouble open diagnostics window" })


----------------------------------------- nvim_spectre -----------------------------------------
map("n", "<C-f>", "<cmd>lua require(\"spectre\").open_file_search({select_word=true})<CR>",
  { desc = "nvim_spectre search on current file" })

map("v", "<C-f>", "<cmd>lua require(\"spectre\").open_file_search({select_word=true})<CR>",
  { desc = "nvim_spectre search currently highlighted word on current file" })

-- nvim_spectre find menu
map("n", "<leader>fr", "<cmd>lua require(\"spectre\").toggle()<CR>", { desc = "nvim_spectre toggle find & replace" })
map("v", "<leader>fr", "<cmd>lua require(\"spectre\").open_visual() <CR>",
  { desc = "nvim_spectre toggle find & replace on currently highlighted word" })


----------------------------------------- move -----------------------------------------
map("n", "<S-C-Up>", "<cmd>MoveLine(-1)<CR>", { desc = "move current line up" })
map("n", "<S-C-Down>", "<cmd>MoveLine(1)<CR>", { desc = "move current line down" })

map("v", "<S-C-Up>", ":MoveBlock(-1)<CR>", { desc = "move selected block up", silent = true })
map("v", "<S-C-Down>", ":MoveBlock(1)<CR>", { desc = "move selected block down", silent = true })


----------------------------------------- text_case -----------------------------------------
-- text_case code menu
map({ "n", "v" }, "<leader>co", "<cmd>TextCaseOpenTelescope<CR>", { desc = "text_case open menu" })


----------------------------------------- nvzone: menu -----------------------------------------
vim.keymap.set("n", "<C-t>", function()
  require("menu").open("default")
end, {})

map({ "n", "v" }, "<RightMouse>", function()
  require('menu.utils').delete_old_menus()

  vim.cmd.exec '"normal! \\<RightMouse>"'

  -- clicked buf
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"
  print(options)

  require("menu").open(options, { mouse = true })
end, {})


----------------------------------------- DAP -----------------------------------------
-- dap menu
map("n", "<leader>dr", "<cmd>DapNew<CR>", { desc = "dap start one/more debug sessions", silent = true });
map("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "dap toggle breakpoint", silent = true });
map("n", "<leader>dd", "<cmd>DapClearBreakpoints<CR>", { desc = "dap clear all breakpoints", silent = true });
map("n", "<leader>dc", "<cmd>DapContinue<CR>", { desc = "dap continue", silent = true });
map("n", "<leader>di", "<cmd>DapStepInto<CR>", { desc = "dap step into", silent = true });
map("n", "<leader>do", "<cmd>DapStepOut<CR>", { desc = "dap step out", silent = true });
map("n", "<leader>dn", "<cmd>DapStepOver<CR>", { desc = "dap step over", silent = true });
map("n", "<leader>dx", "<cmd>DapTerminate<CR>", { desc = "dap teminate", silent = true });

