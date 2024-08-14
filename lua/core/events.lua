local autocmd = vim.api.nvim_create_autocmd

-- NOTE: To view all registered events, run ':autocmd'

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- On save pre-hook.
--  - Trim whitespaces.
autocmd('BufWritePre', {
  pattern = '*',
  command = "execute 'StripTrailingWhitespace'",
})

-- reload some chadrc options on-save
autocmd("BufWritePost", {
  pattern = vim.tbl_map(function(path)
    return vim.fs.normalize(vim.loop.fs_realpath(path))
  end, vim.fn.glob(vim.fn.stdpath "config" .. "/lua/custom/**/*.lua", true, true, true)),
  group = vim.api.nvim_create_augroup("ReloadNvChad", {}),

  callback = function(opts)
    local fp = vim.fn.fnamemodify(vim.fs.normalize(vim.api.nvim_buf_get_name(opts.buf)), ":r") --[[@as string]]
    local app_name = vim.env.NVIM_APPNAME and vim.env.NVIM_APPNAME or "nvim"
    local module = string.gsub(fp, "^.*/" .. app_name .. "/lua/", ""):gsub("/", ".")

    require("plenary.reload").reload_module "base46"
    require("plenary.reload").reload_module(module)
    require("plenary.reload").reload_module "custom.chadrc"

    config = require("core.utils").load_config()

    vim.g.nvchad_theme = config.ui.theme
    vim.g.transparency = config.ui.transparency

    -- statusline
    require("plenary.reload").reload_module("nvchad.statusline." .. config.ui.statusline.theme)
    vim.opt.statusline = "%!v:lua.require('nvchad.statusline." .. config.ui.statusline.theme .. "').run()"

    -- tabufline
    if config.ui.tabufline.enabled then
      require("plenary.reload").reload_module "nvchad.tabufline.modules"
      vim.opt.tabline = "%!v:lua.require('nvchad.tabufline.modules').run()"
    end

    require("base46").load_all_highlights()
    -- vim.cmd("redraw!")
  end,
})

-- Event triggers lazy loading git-dependant plugins if in a .git working directory.
-- Lazy load plugins:
--  - gitsigns.nvim
--  - neogit
autocmd({ "BufRead" }, {
  group = vim.api.nvim_create_augroup("GitPluginsLazyLoad", { clear = true }),
  callback = function()
    vim.fn.jobstart({ "git", "-C", vim.loop.cwd(), "rev-parse" },
      {
        on_exit = function(_, return_code)
          if return_code == 0 then
            vim.api.nvim_del_augroup_by_name "GitPluginsLazyLoad"
            vim.schedule(function()
              require("lazy").load({ plugins = { "gitsigns.nvim", "neogit" } })
            end)
          end
        end
      }
    )
  end,
})


