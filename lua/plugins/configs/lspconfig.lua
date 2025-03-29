-- See https://www.andersevenrud.net/neovim.github.io/lsp/configurations/
dofile(vim.g.base46_cache .. "lsp")
require "nvchad.lsp"

local M = {}
local utils = require "core.utils"
local lspconfig = require "lspconfig";
local configs = require "lspconfig.configs";

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
  end,
})


-------------------------------------- custom lsp setup ------------------------------------------
-- PlantUML LSP
if not configs.plantuml_lsp then
  -- Follow https://github.com/ptdewey/plantuml-lsp
  configs.plantuml_lsp = {
    default_config = {
      cmd = {
        -- go install github.com/ptdewey/plantuml-lsp@latest
        "plantuml-lsp",

        -- Extract using "plantuml -extractstdlib"
        "--stdlib-path=/opt/plantuml/stdlib/",

        -- With plantuml executable and available from your PATH there is a simpler method:
        "--exec-path=plantuml",
      },
      filetypes = { "plantuml" },
      root_dir = function(fname)
        return lspconfig.util.find_git_ancestor(fname) or lspconfig.util.path.dirname(fname)
      end,
      settings = {},
    }
  };

  lspconfig.plantuml_lsp.setup{};
end


return M
