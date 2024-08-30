-- All plugins have lazy=true by default, to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {
  "nvim-lua/plenary.nvim",

  {
    "NvChad/base46",
    branch = "v2.0",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "NvChad/ui",
    branch = "v2.0",
    lazy = false,
  },

  -- VimWiki: https://github.com/vimwiki/vimwiki
  {
    "vimwiki/vimwiki",
    event = "VeryLazy"
  },

  {
    "NvChad/nvterm",
    init = function()
      require("core.utils").load_mappings "nvterm"
    end,
    opts = function()
      return require("plugins.configs.nvterm");
    end,
    config = function(_, opts)
      require "base46.term"
      require("nvterm").setup(opts)
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    init = function()
      require("core.utils").lazy_load "nvim-colorizer.lua"
    end,
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- execute colorizer as soon as possible
      vim.defer_fn(function()
        require("colorizer").attach_to_buffer(0)
      end, 0)
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      return { override = require "nvchad.icons.devicons" }
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "devicons")
      require("nvim-web-devicons").setup(opts)
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    init = function()
      require("core.utils").lazy_load "indent-blankline.nvim"
    end,
    opts = function()
      return require("plugins.configs.blankline");
    end,
    config = function(_, opts)
      require("core.utils").load_mappings("indent_blankline");
      dofile(vim.g.base46_cache .. "blankline");
      require("ibl").setup(opts);
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      require("core.utils").lazy_load "nvim-treesitter"
    end,
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "plugins.configs.treesitter"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "syntax")
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    ft = { "gitcommit", "diff" },
    opts = function()
      return require("plugins.configs.gitsigns");
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "git");
      require("gitsigns").setup(opts);
    end,
  },

  -- https://github.com/alvan/vim-closetag
  {
    "alvan/vim-closetag",
    event = "VeryLazy",
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    opts = function()
      return require "plugins.configs.mason"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "mason")
      require("mason").setup(opts)

      -- custom nvchad cmd to install all mason binaries listed
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
      end, {})

      vim.g.mason_binaries_list = opts.ensure_installed
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = function()
      return require('plugins.configs.mason-lspconfig');
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    init = function()
      require("core.utils").lazy_load "nvim-lspconfig"
      require("core.utils").load_mappings "lspconfig"
    end,
    config = function()
      return require "plugins.configs.lspconfig"
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
          require("plugins.configs.luasnip")(opts)
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
      return require "plugins.configs.cmp"
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
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
    init = function()
      require("core.utils").load_mappings "comment"
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    init = function()
      require("core.utils").load_mappings "nvimtree"
    end,
    opts = function()
      return require "plugins.configs.nvimtree"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "nvimtree")
      require("nvim-tree").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    cmd = "Telescope",
    init = function()
      require("core.utils").load_mappings "telescope"
    end,
    opts = function()
      return require "plugins.configs.telescope"
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "telescope")
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  -- Only load whichkey after all the gui
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    init = function()
      require("core.utils").load_mappings "whichkey"
    end,
    cmd = "WhichKey",
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
    end,
  },

  -- Large file plugin, which disables hungry resources when opening
  -- large files.
  {
    "LunarVim/bigfile.nvim",
    event = "BufReadPre",
    opts = {
      filesize = 2, -- size of file in MiB for which to trigger.
    },
    config = function(_, opts)
      require('bigfile').setup(opts)
    end,
  },

  -- Tabular plugin for aligning text on  a given symbol, like an '='
  -- sign. (:Tab /=)
  {
    "godlygeek/tabular",
    event = "VeryLazy",
    init = function()
      require("core.utils").load_mappings "tabular"
    end,
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
      };
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
    init = function()
      require("core.utils").load_mappings "glance"
    end,

    config = function()
      require "plugins.configs.glance"
    end,
  },

  -- Ouroboros. Opens .cc of header and header of .cc
  {
    'jakemason/ouroboros.nvim',
    event = "VeryLazy",
    init = function()
      require("core.utils").load_mappings "ouroboros"
    end,
    config = function()
      require('ouroboros').setup({
        extension_preferences_table = {
          c   = {h = 2, hpp = 1},
          h   = {c = 3, cc = 2, cpp = 1},
          cpp = {hpp = 2, h = 1},
          cc  = {hpp = 2, h = 1},
          hpp = {cpp = 1, cc = 2, c = 3},
        },
        -- if this is true and the matching file is already open in a pane, we'll
        -- switch to that pane instead of opening it in the current buffer
        switch_to_open_pane_if_possible = false,
      })
    end,
  },

  -- neogit An interactive and powerful Git interface for Neovim, inspired by Magit
  {
    "NeogitOrg/neogit",
    init = function()
      require("core.utils").load_mappings "neogit"
    end,

    config = function()
      require "plugins.configs.neogit"
    end,

    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
    },
  },

  -- Trouble | better diognostics tool
  {
    "folke/trouble.nvim",
    event = "LspAttach",
    init = function()
      require("core.utils").load_mappings "trouble"
    end,
    opts = function()
      return require "plugins.configs.trouble"
    end
  },

  -- todo highlight and tracking comments
  {
    "folke/todo-comments.nvim",
    event = "LspAttach",
    init = function()
      require("core.utils").load_mappings "todo_comments"
    end,
    opts = require("plugins.configs.todo_comments"),
  },

  -- Notification UI
  --   For API docs ":h fidget.api"
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = function()
      return require("plugins.configs.fidget")
    end,
  },

  -- Find & Replace
  {
    "nvim-pack/nvim-spectre",
    event = "VeryLazy",
    init = function()
      require("core.utils").load_mappings("nvim_spectre");
    end,
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
  },

  -- Move selected lines
  {
    "fedepujol/move.nvim",
    event = "VeryLazy",
    init = function()
      require("core.utils").load_mappings("move");
    end,
    opts = require("plugins.configs.move"),
  },

  -- Flatten - Enables opening files in current open nvim buffer
  {
    "willothy/flatten.nvim",
    config = true,
    opts = require("plugins.configs.flatten"),

    -- Ensure enough delay until terminal is configured.
    lazy = false,
    priority = 1001,
    dependencies = {
      "NvChad/nvterm",
    },

  },
}

local config = require("core.utils").load_config()

if #config.plugins > 0 then
  table.insert(default_plugins, { import = config.plugins })
end

require("lazy").setup(default_plugins, config.lazy_nvim)
