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

-- Git remote commands.

-- Function to get the current Git remote URL
local function get_git_remote_url()
  local remote_url = vim.fn.system("git config --get remote.origin.url")

  -- Trim any trailing newline characters
  remote_url = remote_url:gsub("%s+", "");

  -- Remove any '.git' at the end.
  remote_url = remote_url:gsub("%.git$", "");

  -- Check if the command was successful
  if vim.v.shell_error ~= 0 then
    print("Not in a Git repository or error retrieving remote URL.")
    return nil
  end

  return remote_url
end

-- Function to get head commit.
local function get_git_head_commit()
  local head_commit = vim.fn.system("git rev-parse HEAD");
  return head_commit:gsub("%s+", "");
end

new_cmd("CopyGithubURLFile", function ()
  -- Get the current relative file name.
  local current_buf = vim.api.nvim_get_current_buf();
  local current_file = vim.api.nvim_buf_get_name(current_buf);
  local relative_path = vim.fn.fnamemodify(current_file, ":.");

  -- Construct the URL.
  local git_remote_url = get_git_remote_url();
  if not git_remote_url then
    return
  end
  local head_commit = get_git_head_commit();

  local remote_url = string.format(
    "%s/blob/%s/%s",
    git_remote_url,
    head_commit,
    relative_path
  );

  -- Copy remote URL to clipboard.
  vim.fn.setreg('+', remote_url);
  print(string.format("Copied: %s", remote_url));
end, {});

-- User Command that copies the selected line range to a remote
-- git URL into the clipboard.
--
-- DEBUG:
-- Opts is a tables that contains:
-- {
--   name,
--   args,
--   fargs,
--   nargs,
--   bang,
--   line1,
--   line2,
--   range,
--   count,
--   reg,
--   mods,
--   smods = {
--     browse,
--     confirm,
--     emsg_silent,
--     hide,
--     horizontal,
--     keepalt,
--     keepjumps,
--     keepmarks,
--     keeppatterns,
--     lockmarks,
--     noautocmd,
--     noswapfile,
--     sandbox,
--     silent,
--     split,
--     tab,
--     unsilent,
--     verbose,
--     vertical,
--   }
-- }
--
new_cmd("CopyGithubURLSelectedLines", function (opts)
  -- Get the current relative file name.
  local current_buf = vim.api.nvim_get_current_buf();
  local current_file = vim.api.nvim_buf_get_name(current_buf);
  local relative_path = vim.fn.fnamemodify(current_file, ":.");

  -- Construct the URL.
  local filename_with_line_numbers = string.format("%s#L%d-L%d", relative_path, opts.line1, opts.line2);

  local git_remote_url = get_git_remote_url();
  if not git_remote_url then
    return
  end

  local head_commit = get_git_head_commit();
  local remote_url = string.format(
    "%s/blob/%s/%s",
    git_remote_url,
    head_commit,
    filename_with_line_numbers
  );

  -- Copy remote URL to clipboard.
  vim.fn.setreg('+', remote_url);
  print(string.format("Copied: %s", remote_url));
end, {
  desc = "Copies a git remote url from the selected lines",
  range = true,
});


