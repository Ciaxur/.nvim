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
