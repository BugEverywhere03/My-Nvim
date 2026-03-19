local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files,
    { desc = 'Telescope [F]ind [F]iles' })
vim.keymap.set('n', '<leader>fg', function()
	local status = pcall(builtin.git_files)
	if not status then
		builtin.find_files()
	end
end, { desc = 'Telescope [F]ind [G]it [F]iles'})
vim.keymap.set('n', '<leader>fw' , function()
     builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = 'Telescope [F]ind Project By [W]ord' })
vim.keymap.set('n' , '<leader>fb', builtin.buffers, { desc = "Telescope [F]ind"
.. "[B]uffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc = "Telescope [F]ind"
.. "[H]elp [T]ags"})
vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {desc = "Telescope [F]ind"
.. "[O]ld Files"})
vim.keymap.set('n', '<leader>fts', builtin.treesitter, { desc = "Telescope [F]ind"
.. "[Treesitter]"})

