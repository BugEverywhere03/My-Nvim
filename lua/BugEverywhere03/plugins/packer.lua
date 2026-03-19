vim.cmd ([[packadd packer.nvim]])

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '*',
        requires = {
	   	    { 'nvim-lua/plenary.nvim' }
   	    }
    }
    use {
    	"rose-pine/neovim",
    	as = "rose-pine",
    	config = function()
    		vim.cmd("colorscheme rose-pine")
        end
    }
    use {
 	    'nvim-treesitter/nvim-treesitter',
	    lazy = false,
	    build = ':TSUpdate'
    }
    use {'mfussenegger/nvim-jdtls',
            requires = {
                'mfussenegger/nvim-dap'
            }
    }
    use { 'mfussenegger/nvim-dap',
        requires = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio"
        }
    }
    use ('theprimeagen/harpoon')
    use ('mbbill/undotree')
    use ('tpope/vim-fugitive')
    use ('williamboman/mason.nvim')
    use ('williamboman/mason-lspconfig.nvim')
    use ('neovim/nvim-lspconfig')
    use ('hrsh7th/cmp-nvim-lsp')
    use ('hrsh7th/cmp-buffer')
    use ('hrsh7th/cmp-path')
    use ('hrsh7th/cmp-cmdline')
    use ('hrsh7th/nvim-cmp')
    use ('nvim-treesitter/nvim-treesitter-context')
    use (
        "loctvl842/monokai-pro.nvim"
    )
    use({
            "stevearc/oil.nvim",
    })
    use 'nvim-tree/nvim-web-devicons'
    use ('jay-babu/mason-nvim-dap.nvim')
end)

