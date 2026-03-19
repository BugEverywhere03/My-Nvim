-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.number = true -- display line number
vim.opt.relativenumber = true -- display relative lines number
vim.opt.numberwidth = 2 -- set width of line number column
vim.opt.signcolumn = "yes" -- always show sign column
vim.opt.wrap = false -- display line as single line
vim.opt.scrolloff = 10 -- number of lines to keep above/below cursor
vim.opt.sidescrolloff = 8 -- number of columns to keep to the left/right of cursor

-- Tab spacing/behavior
vim.opt.expandtab = true -- convert tab to space
vim.opt.shiftwidth = 4 -- number of spaces inserted for each indentation level
vim.opt.tabstop = 4 -- number of spaces inserted for tab character
vim.opt.softtabstop = 4 -- number of spaces inserted for <Tab> key
vim.opt.smartindent = true -- enable smart indentation
vim.opt.breakindent = true -- enable line breaking indentation

-- Genaral Behaviors
vim.opt.backup = false -- disable backup file creation
vim.opt.clipboard = "unnamedplus" -- enable systems clipboard access
vim.opt.conceallevel = 0 -- show concealed characters in markdown files
vim.opt.fileencoding = "utf-8" -- set file encoding to UTF-8
vim.opt.undodir = os.getenv('HOME') .. "/.nvim/undodir"
vim.opt.undofile = true
vim.opt.termguicolors = true -- enable terminal GUI colors
vim.opt.splitbelow = true -- force horizontal splits below current window
vim.opt.splitright = true -- force vertical splits right of current window
vim.opt.colorcolumn = "100"
vim.g.mapleader = " "
-- vim.g.loaded_netrw = 1
-- vim.g.netrwPlugin = 1
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_liststyle = 0 -- set sytle netrw display tree style
vim.opt.timeoutlen = 800 -- set timeout for mapped sequences
vim.opt.updatetime = 50 -- set faster completion
vim.opt.writebackup = false -- prevent editing of files being edited elsewhere
vim.opt.cursorline = true -- highlight current line

-- Searching Behaviors
vim.opt.hlsearch = false  --
vim.opt.ignorecase = true -- ignore case in search
vim.opt.smartcase = true -- match case if explicity starter
vim.opt.incsearch = true -- 
vim.opt.isfname:append("@-@")

