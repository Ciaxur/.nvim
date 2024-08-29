-- n, v, i, t = mode names

local M = {}

M.general = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "Beginning of line" },
    ["<C-e>"] = { "<End>", "End of line" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "Move left" },
    ["<C-l>"] = { "<Right>", "Move right" },
    ["<C-j>"] = { "<Down>", "Move down" },
    ["<C-k>"] = { "<Up>", "Move up" },
  },

  n = {
    ["<Esc>"] = { "<cmd> noh <CR>", "Clear highlights" },
    -- switch between windows
    ["<C-Left>"]  = { "<C-w>h", "Window left" },
    ["<C-Right>"] = { "<C-w>l", "Window right" },
    ["<C-Down>"]  = { "<C-w>j", "Window down" },
    ["<C-Up>"]    = { "<C-w>k", "Window up" },

    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "Save file" },

    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },

    -- line numbers
    ["<leader>n"] = { "<cmd> set nu! <CR>", "Toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "Toggle relative number" },

    -- Manipulate split windows
    ["<leader>z"]  = { "<cmd> ToggleMaximize <CR>", "Toggle maximizing the active window" },
    ["<leader>\\"] = { "<cmd> vsplit <CR>", "Vertically split current window" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },

    -- new buffer
    ["<leader>b"]  = { "<cmd> enew <CR>", "New buffer" },
    ["<leader>?"]  = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },

    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "LSP formatting",
    },
  },

  t = {
    ["<C-x>"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode" },
  },

  v = {
    ["<Up>"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    ["<Down>"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["<"] = { "<gv", "Indent line" },
    [">"] = { ">gv", "Indent line" },

    -- Format highlighted text
    ["<leader>fm"] = {
      function ()
        -- Not specifying a range, defaults to selected buffer in visual mode.
        vim.lsp.buf.format({async = true});
      end,
      "Format highlighted block",
    },
  },

  x = {
    ["j"] = { 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', "Move down", opts = { expr = true } },
    ["k"] = { 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', "Move up", opts = { expr = true } },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', "Dont copy replaced text", opts = { silent = true } },
  },
}

local go_to_buffer_index = function (buf_index)
  local bufs     = vim.t.bufs;
  local bufs_len = #bufs;
  local set_buf  = vim.api.nvim_set_current_buf;

  if bufs_len >= buf_index then
    set_buf(bufs[buf_index])
  end
end

M.tabufline = {
  plugin = true,

  n = {
    -- Alt+N where N is a number key. Goes to the tab buffer with respect to the number key.
    ["<A-1>"] = {
      function()
        go_to_buffer_index(1)
      end,
      "Goes to buffer 1"
    },
    ["<A-2>"] = {
      function()
        go_to_buffer_index(2)
      end,
      "Goes to buffer 2"
    },
    ["<A-3>"] = {
      function()
        go_to_buffer_index(3)
      end,
      "Goes to buffer 3"
    },
    ["<A-4>"] = {
      function()
        go_to_buffer_index(4)
      end,
      "Goes to buffer 4"
    },
    ["<A-5>"] = {
      function()
        go_to_buffer_index(5)
      end,
      "Goes to buffer 5"
    },
    ["<A-6>"] = {
      function()
        go_to_buffer_index(6)
      end,
      "Goes to buffer 6"
    },
    ["<A-7>"] = {
      function()
        go_to_buffer_index(7)
      end,
      "Goes to buffer 7"
    },
    ["<A-8>"] = {
      function()
        go_to_buffer_index(8)
      end,
      "Goes to buffer 8"
    },
    ["<A-9>"] = {
      function()
        go_to_buffer_index(9)
      end,
      "Goes to buffer 9"
    },

    -- cycle through buffers
    ["<tab>"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },

    ["<S-tab>"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },

    -- close buffer + hide terminal buffer
    ["<leader>x"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions
  n = {
    ["<leader>lD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "LSP declaration",
    },

    ["K"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "LSP hover",
    },

    ["<leader>li"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "LSP implementation",
    },

    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "LSP signature help",
    },

    ["<leader>cr"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },

    ["<leader>lgf"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Floating diagnostic",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev { float = { border = "rounded" } }
      end,
      "Goto prev",
    },

    ["]d"] = {
      function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
      end,
      "Goto next",
    },

    ["<leader>lm"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "Show diagnostics tab",
    },

    ["<leader>lwa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "Add workspace folder",
    },

    ["<leader>lwr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "Remove workspace folder",
    },

    ["<leader>lwl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "List workspace folders",
    },
  },

  v = {
    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<A-E>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },

    -- focus
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
  },
}

M.telescope = {
  plugin = true,

  n = {
  -- Toggle menu
   ["<leader>t"]   = { '<cmd>Telescope<cr>', 'Opens the Telescope window.' },
   ["<leader>tc"]  = { '<cmd>Telescope commands<cr>', 'Open Telescope commands window.' },

    -- search
    ["<leader>rg"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },

    -- find
    -- Ctrl+P
    ["<C-p>"]      = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>fs"] = { "<cmd> lua require'telescope.builtin'.lsp_document_symbols{} <CR>", "Opens a window with document symbols" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "Find all" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
    ["<leader>fz"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "Find in current buffer" },

    -- git
    ["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
    ["<leader>gs"] = { "<cmd> Telescope git_status <CR>", "Git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

    ["<leader>ma"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
  },
}

M.tabular = {
  plugin = true,

  -- Visual mode
  v = {
    ['<leader>tf'] = { '<cmd>Tabular /=<cr>', 'Aligned selection on equals character' },
  },
}

M.nvterm = {
  plugin = true,

  t = {
    -- toggle in terminal mode
    ["<A-i>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "Toggle vertical term",
    },
  },

  n = {
    -- toggle in normal mode
    ["<A-i>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "Toggle horizontal term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle "vertical"
      end,
      "Toggle vertical term",
    },

    -- new
    ["<leader>h"] = {
      function()
        require("nvterm.terminal").new "horizontal"
      end,
      "New horizontal term",
    },

    ["<leader>v"] = {
      function()
        require("nvterm.terminal").new "vertical"
      end,
      "New vertical term",
    },
  },
}

M.whichkey = {
  plugin = true,

  n = {
    ["<leader>wK"] = {
      function()
        vim.cmd "WhichKey"
      end,
      "Which-key all keymaps",
    },
    ["<leader>wk"] = {
      function()
        local input = vim.fn.input "WhichKey: "
        vim.cmd("WhichKey " .. input)
      end,
      "Which-key query lookup",
    },
  },
}

M.indent_blankline = {
  plugin = true,

  n = {},
}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    ["]c"] = {
      function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          package.loaded.gitsigns.next_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to next hunk",
      opts = { expr = true },
    },

    ["[c"] = {
      function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          package.loaded.gitsigns.prev_hunk()
        end)
        return "<Ignore>"
      end,
      "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>ghr"] = {
      function()
        package.loaded.gitsigns.reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>ghp"] = {
      function()
        package.loaded.gitsigns.preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>gb"] = {
      function()
        package.loaded.gitsigns.blame()
      end,
      "Blame line",
    },

    ["<leader>gd"] = {
      function()
        package.loaded.gitsigns.toggle_deleted()
      end,
      "Toggle deleted",
    },

    ["<leader>gu"] = {
      function()
        vim.schedule(function ()
          package.loaded.gitsigns.undo_stage_hunk();
        end)
      end,
      "Undo last staged hunk",
    },
  },

  v = {
    ["<leader>gs"] = {
      function()
        local line0 = vim.fn.getpos("v")[2];
        local line1 = vim.fn.getcurpos()[2];
        local selection_range = { line0, line1 };

        vim.schedule(function ()
          package.loaded.gitsigns.stage_hunk(selection_range);
        end)
      end,
      "Stages currently selected line range",
    },

    ["<leader>gr"] = {
      function()
        local line0 = vim.fn.getpos("v")[2];
        local line1 = vim.fn.getcurpos()[2];
        local selection_range = { line0, line1 };

        vim.schedule(function()
          package.loaded.gitsigns.reset_hunk(selection_range);
        end)
      end,
      "Resets currently selected chunk",
    },
  },
}

M.glance = {
  n = {
    ["<leader>lr"] = { "<cmd>Glance references<CR>",        "Opens references preview" },
    ["<leader>ld"] = { "<cmd>Glance definitions<CR>",       "Opens definitions preview" },
    ["<leader>lT"] = { "<cmd>Glance type_definitions<CR>",  "Opens type definitions preview" },
    ["<leader>li"] = { "<cmd>Glance implementations<CR>",   "Opens implementations preview" },
  }
}

M.trouble = {
  n = {
    ["<leader>km"] = { "<cmd>Trouble diagnostics<CR>", "Opens trouble's diagnostics window" },
  }
}

M.todo_comments = {}

M.nvim_spectre = {
  n = {
    ["<leader>fr"]  = { "<cmd>lua require(\"spectre\").toggle()<CR>", "Toggle Spectre (Find & Replace)." },
    ["<C-f>"]       = { "<cmd>lua require(\"spectre\").open_file_search({select_word=true})<CR>", "Search on current file" },
  },

  v = {
    ["<leader>fr"]  = { "<cmd>lua require(\"spectre\").open_visual() <CR>", "Toggle Spectre on currently highlighted word (Find & Replace)." },
    ["<C-f>"]       = { "<cmd>lua require(\"spectre\").open_file_search({select_word=true})<CR>", "Search currently highlighted word on current file" },
  },
}

M.ouroboros = {
  n = {
    ["<A-o>"] = { "<cmd>Ouroboros<CR>", "Opens .h/.cc related file" },
  }
}

M.neogit = {
  n = {
    ["<leader>gv"] = { "<cmd>Neogit<CR>", "Opens Neogit View" },
  }
}

M.move = {
  n = {
    ["<S-C-Up>"]   = { "<cmd>MoveLine(-1)<CR>", "Moves current line up" },
    ["<S-C-Down>"] = { "<cmd>MoveLine(1)<CR>", "Moves current line down" },
  },

  v = {
    ["<S-C-Up>"]   = { ":MoveBlock(-1)<CR>", "Moves selected lines up" },
    ["<S-C-Down>"] = { ":MoveBlock(1)<CR>", "Moves selected lines down" },
  },
}

return M
