local config = {
  -- Enables or disables indent-blankline
  enabled = true,

  -- Configures what is excluded from indent-blankline
  exclude = {
    buftypes = {
      "terminal",
      "nofile",
      "quickfix",
      "prompt",
    },

    filetypes = {
      "help",
      "terminal",
      "lazy",
      "lspinfo",
      "TelescopePrompt",
      "TelescopeResults",
      "mason",
      "nvdash",
      "nvcheatsheet",
      "",
    }
  },

  -- Sets the amount indent-blankline debounces refreshes in milliseconds.
  debounce = 200,

  indent = {
    char = "┊",
    smart_indent_cap = true,
  },

  -- Configures the scope
  scope = {
    enabled = true,
    highlight = { "Function", "Label" },
  },
};

return config;
