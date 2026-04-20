return {
        name = "sqlls",
        config = {
                cmd = { "sql-language-server", "up", "--method", "stdio" },
                filetypes = { "sql" },
                root_markers = { ".git" },
        },
}
