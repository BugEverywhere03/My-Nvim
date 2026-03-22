local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.completion.spell,
		require("none-ls.diagnostics.eslint"),
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.diagnostics.mypy,
		null_ls.builtins.formatting.isort,
	},
})
-- Set Keymap
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = " [C]ode [F]ormat" })
