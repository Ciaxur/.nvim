-- NOTE: See docs ':h mason-lspconfig-settings'
local lspconfig_options = require('configs.lspconfig')
local lspconfig = require "lspconfig"

-- Configure LSP servers.
-- NOTE: https://kosu.me/blog/breaking-changes-in-mason-2-0-how-i-updated-my-neovim-lsp-config
vim.lsp.config("*", {
  on_attach = lspconfig_options.on_attach,
  capabilities = lspconfig_options.capabilities,
});

vim.lsp.config("lua_ls", {
  on_attach = lspconfig_options.on_attach,
  capabilities = lspconfig_options.capabilities,
  filetypes = { 'lua' },

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
});

vim.lsp.config("pyright", {
  capabilities = lspconfig_options.capabilities,
  on_attach = function(client, bufnr)
    -- Override default spacing.
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
    vim.opt.smartindent = true
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2

    return lspconfig_options.on_attach(client, bufnr)
  end,
});

vim.lsp.config("rust_analyzer", {
  settings = {
    ['rust-analyzer'] = {
      capabilities = lspconfig_options.capabilities,
    },
  },
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  on_attach = function(client)
    -- Override rust's default spacing.
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
    vim.opt.smartindent = true
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
  end,
});

vim.lsp.config("eslint", {
  capabilities = lspconfig_options.capabilities,
});

local default_clangd_config = require('configs.clangd');
vim.lsp.config("clangd", vim.tbl_extend("force", default_clangd_config, {
  capabilities = lspconfig_options.capabilities,
}));

vim.lsp.config("gopls", {
  cmd = { 'gopls' },
  capabilities = lspconfig_options.capabilities,
  on_attach = lspconfig_options.on_attach,
  filetypes = { 'go' },
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
    },
  },
});


-- Mason setup config.
local options = {
  -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
  -- This setting has no relation with the `automatic_installation` setting.
  ---@type string[]
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "clangd",
    "basedpyright",
  },

  ---@type boolean | string[] | { exclude: string[] }
  automatic_enable = true,
}

return options
