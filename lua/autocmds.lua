local autocmd = vim.api.nvim_create_autocmd

-- NOTE: To view all registered events, run ':autocmd'
-- On save pre-hook.
--  - Trim whitespaces.
autocmd('BufWritePre', {
  pattern = '*',
  command = "execute 'StripTrailingWhitespace'",
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

-- cmdpalette.nvim: disable cmp predictions, Tab = cmdline completion, pin palette to top
autocmd('BufWinEnter', {
  group = vim.api.nvim_create_augroup('CmdpaletteCompletion', { clear = true }),
  pattern = 'cmdpalette',
  callback = function(args)
    require('cmp').setup.buffer({ enabled = false })
    vim.keymap.set('i', '<Tab>', '<C-x><C-v>', { buffer = args.buf })

    -- move palette to top of editor
    local win = vim.api.nvim_get_current_win()
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg.relative ~= '' then
      cfg.row = 1
      vim.api.nvim_win_set_config(win, cfg)
    end
  end,
})
