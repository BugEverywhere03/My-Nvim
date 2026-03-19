local springboot_nvim = require('springboot-nvim')
-- Setup Keymap
vim.keymap.set("n", "<leader>Jr", springboot_nvim.boot_run, { desc = "[J]ava [R]un Spring Boot" })
vim.keymap.set("n", "<leader>Jc", springboot_nvim.generate_class, { desc = "[J]ava Create [C]lass"})
vim.keymap.set("n", "<leader>Ji", springboot_nvim.generate_interface, { desc = "[J]ava Create [I]nterface"})
vim.keymap.set("n", "<leader>Je", springboot_nvim.generate_enum, { desc = "[J]ava Create [E]num"})
vim.keymap.set("n", "<leader>sb", function() vim.cmd("SpringBootNewProject") end, { desc = "[S]pring [B]oot New Project"})
-- Setup SpringBoot-Nvim
springboot_nvim.setup({
    on_compile_result = nil,
})
