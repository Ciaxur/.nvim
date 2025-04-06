-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
local utils = require "nvchad.stl.utils"

---@type ChadrcConfig
local M = {}


M.base46 = {
	theme = "tokyonight",
  transparency = true,
}

M.nvdash = { load_on_startup = true }

M.ui = {
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
