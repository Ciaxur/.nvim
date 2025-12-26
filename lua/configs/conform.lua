local options = {
	formatters_by_ft = {
		lua = { "stylua" },
    markdown = { "mdformat" },
    go = { "goimports", "gofmt" },
    rust = { "rustfmt", lsp_format = "fallback" },

    default_format_opts = {
      lsp_format = "fallback",
    },

    -- See :help conform.format for details.
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 500,
      async = true,
    },
	},
}

return options
