local new_cmd = vim.api.nvim_create_user_command

new_cmd("NvChadUpdate", function()
  require "nvchad.updater"()
end, {})

-- Maximizes the active split buffer.
local last_win_view = nil
new_cmd("ToggleMaximize", function ()
  if last_win_view then
    -- Restore the previous window view
    vim.api.nvim_win_set_width(0, last_win_view.width)
    vim.api.nvim_win_set_height(0, last_win_view.height)
    last_win_view = nil
  else
    -- Maximize the current window
    last_win_view = {
      width = vim.api.nvim_win_get_width(0),
      height = vim.api.nvim_win_get_height(0),
    }
    vim.api.nvim_command('wincmd |')
    vim.api.nvim_command('wincmd _')
  end
end, {})
