return {
        name = "dosini_ls",
        config = {
                cmd = { "dosini-lsp", "--stdio" },
                filetypes = { "dosini", "ini" },
                root_markers = { ".git" },
        },
}
