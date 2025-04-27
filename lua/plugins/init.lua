return {
  "nvim-lua/plenary.nvim",

  {
    "nvchad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "nvchad/ui",
    lazy = false,
    config = function()
      require "nvchad"
    end,
  },

  "nvzone/volt",
  "nvzone/menu",
  { "nvzone/minty", cmd = { "Huefy", "Shades" } },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
    end,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    opts = function()
      dofile(vim.g.base46_cache .. "whichkey")
      return {}
    end,
  },

  -- formatting!
  {
    "stevearc/conform.nvim",
    opts = require("configs.conform"),
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "configs.gitsigns"
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = function()
      return require "configs.mason"
    end,
  },

  -- mason extension that allows ease of lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    event = "User FilePost",
    opts = function()
      return require('configs.mason-lspconfig');
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require("configs.lspconfig").defaults();
    end,
    opts = function ()
      return require("configs.lspconfig");
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "configs.cmp"
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n",          desc = "Comment toggle current line" },
      { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n",          desc = "Comment toggle current block" },
      { "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
    },
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  ----------------------
  --- Telescope plugins
  ----------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Whitespaces.
  {
    'jdhao/whitespace.nvim',
    event = "VimEnter",
  },

 -- Glance. Code reference and definitions preview.
  {
    'DNLHC/glance.nvim',
    event = "VeryLazy",
    config = function()
      require "configs.glance"
    end,
  },

  -- neogit An interactive and powerful Git interface for Neovim, inspired by Magit
  {
    "NeogitOrg/neogit",
    config = function()
      require "configs.neogit"
    end,

    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
    },
  },

  -- Tabular plugin for aligning text on  a given symbol, like an '='
  -- sign. (:Tab /=)
  {
    "godlygeek/tabular",
    event = "VeryLazy",
  },

  -- Multi-cursors plugin.
  -- NOTE: Mappings can be found on ':h vm-mappings.txt'
  --  This plugin is for vim, used in neovim. Which means the
  --  configs are applied differently.
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      -- Disable default mappings.
      vim.g.VM_default_mappings = 0;

      -- Since this plugin is for vim, we need to do our own custom
      -- mappings.
      vim.g.VM_maps = {
        ["Find Under"]         = "<C-d>",
        ["Find Subword Under"] = "<C-d>",

        -- M = Ctrl
        ["Select Cursor Down"] = "<M-C-Down>",
        ["Select Cursor Up"]   = "<M-C-Up>",

        -- Ctrl+Shift+L
        ["Select All"]         = "<C-L>",
      }
    end,
  },

  -- https://github.com/alvan/vim-closetag
  {
    "alvan/vim-closetag",
    event = "VeryLazy",
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    opts = function()
      return require("configs.gitsigns");
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git");
      require("gitsigns").setup(opts);
    end,
  },

  -- Large file plugin, which disables hungry resources when opening
  -- large files.
  {
    "LunarVim/bigfile.nvim",
    event = "BufReadPre",
    opts = {
      filesize = 1, -- size of file in MiB for which to trigger.
    },
    config = function(_, opts)
      require('bigfile').setup(opts)
    end,
  },

  -- Trouble | better diognostics tool
  {
    "folke/trouble.nvim",
    event = "LspAttach",
    opts = function()
      return require "configs.trouble"
    end
  },

  -- todo highlight and tracking comments
  {
    "folke/todo-comments.nvim",
    event = "LspAttach",
    opts = require("configs.todo_comments"),
  },

  -- Notification UI
  --   For API docs ":h fidget.api"
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = function()
      return require("configs.fidget")
    end,
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function ()
      local nvim_notify_config = require("configs.nvim_notify")
      nvim_notify_config.replace_vim_notify();

      require("notify").setup(nvim_notify_config);
    end,
  },

  -- Find & Replace
  {
    "nvim-pack/nvim-spectre",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
  },

  -- Move selected lines
  {
    "fedepujol/move.nvim",
    event = "VeryLazy",
    opts = require("configs.move"),
  },

  -- Flatten - Enables opening files in current open nvim buffer
  {
    "willothy/flatten.nvim",
    config = true,
    opts = require("configs.flatten"),

    -- Ensure enough delay until terminal is configured.
    lazy = false,
    priority = 1001,
    dependencies = {
      "NvChad/nvterm",
    },
  },

  -- text-case - Mutate text. Uppercase/Lowercase/Cammelcase/etc...
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local config = require("configs.text_case");
      require("textcase").setup(config);
      require("telescope").load_extension("textcase");
    end,
    event = "BufEnter",
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  -- PlantUML Syntax
  {
    "aklt/plantuml-syntax",
    ft = "plantuml",
  },

  ----------------------
  --- Debug tools
  ----------------------
  -- Debug Adapter Client (DAP)
  {
    "mfussenegger/nvim-dap",
    event = "LspAttach",
    config = function ()
      local dap = require("dap")
      local dap_configs = require("configs.dap")
      dap.configurations = vim.tbl_extend(
        "force",
        dap.configurations,
        dap_configs.configurations
      );

      dap.adapters = vim.tbl_extend(
        "force",
        dap.adapters,
        dap_configs.adapters
      );
    end,
    opts = function ()
      return require("configs.dap")
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    event = "VeryLazy",
    config = function ()
      require("configs.dapui");
    end
    -- More info on configs -> :h dapui.setup()
  },
}
