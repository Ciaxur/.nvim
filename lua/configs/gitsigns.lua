dofile(vim.g.base46_cache .. "git")

local config = {
  -- Don't show signs for staged hunks.
  signs_staged_enable = false,

  signs = {
    add = { text = "│" },
    change = { text = "│" },
    delete = { text = "󰍵" },
    topdelete = { text = "‾" },
    changedelete = { text = "󱕖" },
    untracked = { text = "│" },
  },
  signs_staged = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  numhl = true,

  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 800,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
};

return config;
