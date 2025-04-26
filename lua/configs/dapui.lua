local dap = require("dap");
local dapui = require("dapui");

-- Init dapui
dapui.setup();

-- Setup dap listeners to interface with dap-ui
dap.listeners.before.attach.dapui_config = function()
  dapui.open();
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open();
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close();
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close();
end

