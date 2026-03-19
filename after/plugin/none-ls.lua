local none_ls = require("null-ls")

none_ls.setup({
    sources = {
        none_ls.builtins.formatting.stylua,
        require("none-ls.diagnostics.eslint_d"),
        none_ls.builtins.formatting.prettier,
    }
})

-- Set Keymap
vim.keymap.set("n", "<leader>cf" , vim.lsp.buf.format, { desc = " [C]ode [F]ormat" })
