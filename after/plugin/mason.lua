-- Config UI for Mason
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
		backdrop = 60,
		border = "rounded",
		width = 0.8,
		height = 0.9,
	},
})
vim.api.nvim_set_hl(0, "MasonNormal", { fg = "#fffadc", bold = true })
vim.api.nvim_set_hl(0, "MasonHeader", { bg = "#89b4fa", fg = "#1e1e2e", bold = true })
vim.api.nvim_set_hl(0, "MasonHeaderSecondary", { bg = "#362310", fg = "#1e1e2e", bold = true })
-- vim.api.nvim_set_hl(0, "MassonHighlight", { bg = "#64492b", fg = "#fff8dc", bold = true })
-- vim.api.nvim_set_hl(0, "MasonMuted", { bg = "#91754d", fg = "#fafafa", bold = true })
require("mason-nvim-dap").setup({
	ensure_installed = { "debugpy", "java-debug-adapter", "java-test" },
})

local cmp_lsp = require("cmp_nvim_lsp")
local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
-- vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
--  return vim.empty_dict()
--end
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
	border = "rounded",
	width = 70,
	height = 15,
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "rust_analyzer", "ts_ls", "pyright" },
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = capabilities,
			})
		end,
	},
})
vim.lsp.config("ts_ls", {
	settings = {
		capabilites = capabilities,
	},
})
vim.lsp.config("lua_ls", {
	settings = {
		capabilities = capabilities,
	},
})
vim.lsp.config("html", {
	settings = {
		capabilities = capabilities,
	},
})
vim.lsp.config("pyright", {
    settings = {
        capabilities = capabilities,
        python = {
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
            }
        },
    }
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
					},
				},
			},
		},
	},
})
vim.lsp.config("lemminx", {
	settings = {
		filetypes = { "xml", "fxml", "svg" },
	},
})
-- Set Keymap
vim.keymap.set("n", "<leader>ms", vim.cmd.Mason)
vim.keymap.set("n", "<leader>rh", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
vim.keymap.set("n", "<leader>rt", vim.lsp.buf.type_definition, { desc = "[C]ode Goto [D]efinition" })
vim.keymap.set({ "n", "v" }, "<leader>ra", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
vim.keymap.set("n", "<leader>rc", vim.lsp.buf.references, { desc = "[C]ode Goto [R]eferences" })
vim.keymap.set("n", "<leader>ri", vim.lsp.buf.implementation, { desc = "[C]ode Goto [I]mplementation" })
vim.keymap.set("n", "O", vim.lsp.buf.document_symbol, { desc = "[D]ocumnet [S]ymbol" })
vim.lsp.set_log_level("info")
