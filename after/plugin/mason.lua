-- Config UI for Mason
require('mason').setup({
	ui = {
	    icons = {
		    package_installed = "✓",
		    package_pending = "➜",
            package_uninstalled = "✗"
       	},
        backdrop = 60,
 	    border = nil,
	}
})
require('mason-nvim-dap').setup({
    ensure_installed = { 'python', 'java-debug-adapter', 'java-test',}
})

local cmp_lsp = require('cmp_nvim_lsp')
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)
-- vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
  --  return vim.empty_dict()
--end
require('mason-lspconfig').setup({
	ensure_installed = { "lua_ls", "rust_analyzer" ,"ts_ls"},
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup{
                capabilities = capabilities,
            }
        end
    },
})
vim.lsp.config("ts_ls", {
    settings = {
        capabilites = capabilities,
    }
})
vim.lsp.config("lua_ls", {
    settings = {
        capabilities = capabilities,
    }
})
vim.lsp.config("html",{
    settings = {
        css = {
            validate = false,
        }
    },
})
vim.lsp.config("jdtls", {
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-21",
                        path = "/home/bug-every-where-03/.sdkman/candidates/java/current",
                        default = true,
                    }
                }
            }
        }
    }
})
vim.lsp.config("lemminx" , {
    filetypes = { 'xml', 'fxml', 'svg'},
})
-- Set Keymap
vim.keymap.set('n', '<leader>ms', vim.cmd.Mason)
vim.keymap.set("n", "<leader>rh", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
vim.keymap.set("n", "<leader>rt", vim.lsp.buf.type_definition, { desc = "[C]ode Goto [D]efinition" })
vim.keymap.set({"n", "v" }, "<leader>ra", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
vim.keymap.set("n", "<leader>rc", vim.lsp.buf.references , { desc = "[C]ode Goto [R]eferences"})
vim.keymap.set("n", "<leader>ri", vim.lsp.buf.implementation, { desc = "[C]ode Goto [I]mplementation" })
vim.keymap.set("n", "O", vim.lsp.buf.document_symbol, { desc = "[D]ocumnet [S]ymbol" })
vim.lsp.set_log_level("info")
