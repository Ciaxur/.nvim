local config = {
  -- <String, Bool> dictionary of filetypes that should be blocking
  block_for = {
    gitcommit = true,
    gitrebase = true,
  },
  -- Command passthrough
  allow_cmd_passthrough = true,
  -- Allow a nested session to open if Neovim is opened without arguments
  nest_if_no_args = false,
  -- Window options
  window = {
    -- Options:
    -- current        -> open in current window (default)
    -- alternate      -> open in alternate window (recommended)
    -- tab            -> open in new tab
    -- split          -> open in split
    -- vsplit         -> open in vsplit
    -- smart          -> smart open (avoids special buffers)
    -- OpenHandler    -> allows you to handle file opening yourself (see Types)
    --
    open = "smart",
    -- Options:
    -- vsplit         -> opens files in diff vsplits
    -- split          -> opens files in diff splits
    -- tab_vsplit     -> creates a new tabpage, and opens diff vsplits
    -- tab_split      -> creates a new tabpage, and opens diff splits
    -- OpenHandler    -> allows you to handle file opening yourself (see Types)
    diff = "tab_vsplit",
    -- Affects which file gets focused when opening multiple at once
    -- Options:
    -- "first"        -> open first file of new files (default)
    -- "last"         -> open last file of new files
    focus = "first",
  },
};

return config;
