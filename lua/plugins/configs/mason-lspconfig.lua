-- NOTE: See docs ':h mason-lspconfig-settings'
local lspconfig_options = require('plugins.configs.lspconfig');
local lspconfig = require("lspconfig");

local options = {
  -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
  -- This setting has no relation with the `automatic_installation` setting.
  ---@type string[]
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "clangd",
  },

  -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
  -- This setting has no relation with the `ensure_installed` setting.
  -- Can either be:
  --   - false: Servers are not automatically installed.
  --   - true: All servers set up via lspconfig are automatically installed.
  --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
  --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
  ---@type boolean
  automatic_installation = true,

  -- See `:h mason-lspconfig.setup_handlers()`
  ---@type table<string, fun(server_name: string)>?
  handlers = {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function(server_name) -- default handler (optional)
      lspconfig[server_name].setup {
        on_attach = lspconfig_options.on_attach,
        capabilities = lspconfig_options.capabilities,
      };
    end,
    -- Next, you can provide targeted overrides for specific servers.
    ["lua_ls"] = function()
      lspconfig.lua_ls.setup {
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
      };
    end,

    ["pyright"] = function()
      lspconfig.pyright.setup {
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
      };
    end,

    ["rust_analyzer"] = function()
      lspconfig.rust_analyzer.setup {
        -- Server-specific settings. See `:help lspconfig-setup`
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
      };
    end,

    ["eslint"] = function()
      lspconfig.eslint.setup {
        capabilities = lspconfig_options.capabilities,
      };
    end,

    ["clangd"] = function()
      lspconfig.clangd.setup(require('plugins.configs.clangd'));
    end,

    ["gopls"] = function()
      lspconfig.gopls.setup {
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
      };
    end,
  },
}

return options
