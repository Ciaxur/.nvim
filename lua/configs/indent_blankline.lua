---@module "ibl"
---@type ibl.config
return {
  indent = {
    char = '▏',
    tab_char = '▏',
  },

  -- BUG: not sure why but this doesn't work. It is supposed to highlight the scope you're in but
  -- doesn't work. Spent a LOT of time figuring out why. It might be something to do with Treesitter
  -- and ibl incompatibility but am not sure.
  scope = {
    enabled = true,
    show_start = true,
    show_end = false,
    show_exact_scope = true,
    highlight = "IblScope",
  },
};
