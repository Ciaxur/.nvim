local nvim_notify = require("notify");
local async = require("plenary.async");

M = {
  background_colour = "#FFFFFF",
  fps = 60,
  icons = {
    DEBUG = "",
    ERROR = "",
    INFO = "",
    TRACE = "✎",
    WARN = ""
  },
  level = 2,
  minimum_width = 50,
  render = "default",
  stages = "fade_in_slide_out",
  time_formats = {
    notification = "%T",
    notification_history = "%FT%T"
  },
  timeout = 5000,
  top_down = true
};

M.replace_vim_notify = function ()
  vim.notify = function (msg, level, opts)
    async.run(function ()
      nvim_notify.async(msg, level, opts).events.close();
    end);
  end
end

return M;
