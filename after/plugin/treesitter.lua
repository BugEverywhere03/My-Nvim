require'nvim-treesitter'.setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath('data') .. '/site',
    indent = {
        enable = true,
    },
    highlight = {
        enable = true,
        disable = function(lang, buf)
            if lang == 'html' then
                print('DISABLE' + lang)
            end
            -- Highlight if file type < 100Kb
            local max_filesize = 100 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                vim.notify(
                    "File larger than 100KB treesitter disabled for performance",
                    vim.log.levels.WARN,
                    { title = "Treesitter" }
                )
                return true
            end
        end,
        additional_vim_regex_highlighting = { "markdown"},
    }
}
require'nvim-treesitter'.install (
    { 'rust', 'zig', 'vim', 'vimdoc', 'xml', 'yaml', 'typescript', 'jsx',
      'json', 'java', 'html', 'html_tags', 'dockerfile', 'css', 'cpp', 'csv',
      'bash', 'jsdoc', 'javascript', 'python', 'git_config', 'git_rebase',
      'gitcommit', 'gitignore', 'go', 'javadoc', 'lua', 'luadoc', 'markdown',
      'jsdoc','c_sharp', 'sql', 'tmux'}
):wait(300000)
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'rust', 'javascript', 'zig', 'vim', 'vimdoc', 'xml', 'yaml',
        'typescript', 'jsx', 'json', 'java', 'html', 'html_tags', 'dockerfile',
        'css', 'cpp', 'csv', 'bash', 'jsdoc', 'python', 'javascript', 'tmux'
    },
    callback = function()
        vim.treesitter.start()
    end
})
-- Enable feature folding
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'
-- Enable indetation
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
require('treesitter-context').setup({
    enable = true,
    multiwindow = false,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshol = 20,
    trim_scope = "outer",
    mode = "cursor",
    separator = nil,
    zindex = 20,
    onattach = nil,
})
