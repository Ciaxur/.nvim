-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
local utils = require "nvchad.stl.utils"

---@type ChadrcConfig
local M = {}


M.base46 = {
	theme = "tokyonight",
  transparency = true,
  integrations = { "dap", "cmp" },
}

M.nvdash = { load_on_startup = true }

M.lsp = {
  signature = true,
}

M.colorify = {
  enabled = true,
  mode = "virtual", -- fg, bg, virtual
  virt_text = "󱓻 ",
  highlight = { hex = true, lspvars = true },
}

M.ui = {
  cmp = {
    icons_left = false, -- only for non-atom styles!
    style = "default", -- default/flat_light/flat_dark/atom/atom_colored
    abbr_maxwidth = 60,
    -- for tailwind, css lsp etc
    format_colors = { lsp = true, icon = "󱓻" },
  },

  tabufline = {
    lazyload = false,
    bufwidth = 21,
  },

  statusline = {
    enabled = true,
    theme = "vscode_colored",
    separator_style = "default",
    modules = {
      -- Modified from nvchad/stl/vscode_colored.lua
      file = function ()
        local x = utils.file()

        local current_buf = vim.api.nvim_get_current_buf();
        local current_file = vim.api.nvim_buf_get_name(current_buf);
        local relative_path = vim.fn.fnamemodify(current_file, ":.");
        return "%#StText# " .. x[1] .. " " .. relative_path .. " "
      end,
    },
  },
}

-- nvterm config
M.term = {
  sizes = {
    vsp = 0.5,
    sp = 0.3,
  },

  float = {
    row = 0.1, col = 0.20,
    width = 0.6, height = 0.75,
    relative = "editor",
    border = "single",
  },
};

return M
