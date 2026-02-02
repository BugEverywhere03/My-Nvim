require('mason').setup({
	ui = {
	    icons = {
		package_installed = "✓",
		package_pending = "➜",
            	package_uninstalled = "✗"
       	    }
	}
})
local cmp = require('cmp')
local cmp_lsp = require('cmp_nvim_lsp')
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities())
vim.keymap.set('n', '<leader>m', vim.cmd.Mason)
vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
  return vim.empty_dict()
end
require('mason-lspconfig').setup({
	ensure_installed = { "lua_ls", "rust_analyzer"},
    handlers = {
        function()
            require('lspconfig')[server_name].setup{
                capabilities = capabilities,
            }
        end
    }
})
vim.lsp.config("html",{
    settings = {
        css = {
            validate = fasle,
        }
    },
})
vim.lsp.config("lemminx" , {
    filetypes = { 'xml', 'fxml', 'svg'},
})
vim.lsp.set_log_level("debug")
