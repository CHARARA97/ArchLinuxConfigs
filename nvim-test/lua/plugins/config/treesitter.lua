require('nvim-treesitter').setup({
        ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "python", "rust", "bash", "javascript", "typescript", "html", "css", "json", "yaml", "toml", "markdown", "markdown_inline" },
        highlight = {
                enable = true,
                disable = {},
        },

        indent = {
                enable = true,
        },

        incremental_selection = {
                enable = true,
                keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                },
        },
})
