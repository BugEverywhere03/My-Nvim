local dap = require("dap")
local dap_ui = require("dapui")

dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "Launch Java",
    mainClass = "${file}",  -- tự detect file hiện tại
    timeout = 30000,
  }
}
dap_ui.setup()
dap.listeners.before.launch.dapui_config = function()
    dap_ui.open()
end
-- Set Log-Level
dap.set_log_level("TRACE")
-- Set Keymap
vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "[D]ebug [T]oggle Breakpoint"})
vim.keymap.set("n", "<leader>ds", dap.continue, { desc = "[D]ebug [S]tart" })
vim.keymap.set("n", "<leader>dc", dap_ui.close, { desc = "[D]ebug [C]lose" })

