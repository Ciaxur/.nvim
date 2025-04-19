pcall(function()
  dofile(vim.g.base46_cache .. "syntax")
  dofile(vim.g.base46_cache .. "treesitter")
end)

local options = {
  ensure_installed = { "lua", "python", "c", "cpp", "rust", "luadoc", "printf", "vim", "vimdoc" },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = { enable = true },

  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  -- textobjects = { enable = true },
}

return options
