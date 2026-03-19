vim.api.nvim_create_autocmd("Filetype", {
    pattern = "java",
    callback = function()
           require("BugEverywhere03.config.jdtls").setup_jdtls()
        end
    }
)
