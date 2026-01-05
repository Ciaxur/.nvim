return {
  "nvim-lua/plenary.nvim",

  {
    "nvchad/base46",
    -- NOTE: This commit points to tag v3.0. Currently this just works... it should've been coupled
    -- with nvchad's v2.5. So using the commit pin here for now.
    -- In the future, make sure to couple it.
    commit = "45b336e",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "nvchad/ui",
    lazy = false,
    -- NOTE: Similar to base46's comment. Make sure to couple the pin with nvchad in the future.
    commit = "bea2af0",
    config = function()
      require "nvchad"
    end,
  },

  {
    "nvzone/volt",
    commit = "620de13",
  },
  {
    "nvzone/menu",
    commit = "7a0a4a2",
  },
  {
    "nvzone/minty",
    commit = "aafc9e8",
    cmd = { "Huefy", "Shades" },
  },

  {
    "nvim-tree/nvim-web-devicons",
    branch = "master",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    tag = "v3.9.0",
    main = "ibl",
    event = "VeryLazy",

    dependencies = { 'nvim-treesitter/nvim-treesitter' },

    ---@module "ibl"
    ---@type ibl.config
    opts = require("configs.indent_blankline"),

    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark);

      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    tag = "v1.14.0",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "configs.nvimtree"
    end,
  },

  {
    "folke/which-key.nvim",
    -- commit = "3aab214",
    tag = "v3.17.0",
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
    tag = "v9.1.0",
    opts = function()
      return require("configs.conform")
    end,
  },

  -- lsp stuff
  {
    "mason-org/mason.nvim",
    tag = "v2.1.0",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    opts = function()
      return require "configs.mason"
    end,
  },

  -- mason extension that allows ease of lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    tag = "v2.1.0",
    dependencies = {
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
    },
    event = "User FilePost",
    opts = function()
      return require('configs.mason-lspconfig')
    end,
  },

  {
    "neovim/nvim-lspconfig",
    tag = "v2.5.0",
    event = "User FilePost",
    config = function()
      require("configs.lspconfig").defaults()
    end,
    opts = function ()
      return require("configs.lspconfig")
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    branch = "main",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        tag = "v2.4.1",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("configs.luasnip")(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        branch = "master",
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
    branch = "master",
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
    tag = "v0.2.1",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "configs.telescope"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    tag = "v0.10.0",
    lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = require "configs.treesitter",
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },

  -- Whitespaces.
  {
    "jdhao/whitespace.nvim",
    branch = "master",
    event = "VimEnter",
  },

 -- Glance. Code reference and definitions preview.
  {
    "DNLHC/glance.nvim",
    branch = "master",
    event = "VeryLazy",
    config = function()
      require "configs.glance"
    end,
  },

  -- neogit An interactive and powerful Git interface for Neovim, inspired by Magit
  {
    "NeogitOrg/neogit",
    branch = "master",
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
    branch = "master",
    event = "VeryLazy",
  },

  -- Multi-cursors plugin.
  -- NOTE: Mappings can be found on ':h vm-mappings.txt'
  --  This plugin is for vim, used in neovim. Which means the
  --  configs are applied differently.
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "VeryLazy",
    init = function()
      -- Disable default mappings.
      vim.g.VM_default_mappings = 0

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
    branch = "master",
    event = "VeryLazy",
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    branch = "main",
    ft = { "gitcommit", "diff" },
    event = "User FilePost",
    opts = function()
      return require("configs.gitsigns")
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git")
      require("gitsigns").setup(opts)
    end,
  },

  -- Large file plugin, which disables hungry resources when opening
  -- large files.
  {
    "LunarVim/bigfile.nvim",
    branch = "main",
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
    branch = "main",
    event = "LspAttach",
    opts = function()
      return require "configs.trouble"
    end
  },

  -- todo highlight and tracking comments
  {
    "folke/todo-comments.nvim",
    branch = "main",
    event = "LspAttach",
    opts = require("configs.todo_comments"),
  },

  -- Notification UI
  --   For API docs ":h fidget.api"
  {
    "j-hui/fidget.nvim",
    branch = "main",
    event = "LspAttach",
    opts = function()
      return require("configs.fidget")
    end,
  },

  {
    "rcarriga/nvim-notify",
    branch = "master",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function ()
      local nvim_notify_config = require("configs.nvim_notify")
      nvim_notify_config.replace_vim_notify()

      require("notify").setup(nvim_notify_config)
    end,
  },

  -- Find & Replace
  {
    "nvim-pack/nvim-spectre",
    branch = "master",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
  },

  -- Move selected lines
  {
    "fedepujol/move.nvim",
    branch = "main",
    event = "VeryLazy",
    opts = require("configs.move"),
  },

  -- Flatten - Enables opening files in current open nvim buffer
  {
    "willothy/flatten.nvim",
    branch = "main",
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
    branch = "main",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local config = require("configs.text_case")
      require("textcase").setup(config)
      require("telescope").load_extension("textcase")
    end,
    event = "BufEnter",
  },

  -- PlantUML Syntax
  {
    "aklt/plantuml-syntax",
    branch = "master",
    ft = "plantuml",
  },

  ----------------------
  --- Markdown
  ----------------------
  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    branch = "master",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    branch = "main",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { "markdown" },

    -- :h render-markdown-setup
    opts = {
      completions = { lsp = { enabled = true } },
      render_modes = { 'n', 'c', 't' },
    },
  },

  ----------------------
  --- Debug tools
  ----------------------
  -- Debug Adapter Client (DAP)
  {
    "mfussenegger/nvim-dap",
    branch = "master",
    event = "LspAttach",
    config = function ()
      local dap = require("dap")
      local dap_configs = require("configs.dap")
      dap.configurations = vim.tbl_extend(
        "force",
        dap.configurations,
        dap_configs.configurations
      )

      dap.adapters = vim.tbl_extend(
        "force",
        dap.adapters,
        dap_configs.adapters
      )
    end,
    opts = function ()
      return require("configs.dap")
    end
  },

  {
    "rcarriga/nvim-dap-ui",
    branch = "master",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    event = "VeryLazy",
    config = function ()
      require("configs.dapui")
    end
    -- More info on configs -> :h dapui.setup()
  },
}
