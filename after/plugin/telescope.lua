
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-p>', function() 
	local status = pcall(builtin.git_files)
	if not status then
		builtin.find_files()
	end
end, { desc = 'Telescope find git files'})
vim.keymap.set('n', '<leader>ps' , function()
     builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = 'Telescope find project by word' })

