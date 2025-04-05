-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "tokyonight",
  transparency = true,

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

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
