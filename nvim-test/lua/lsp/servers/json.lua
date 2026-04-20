return {
        name = "jsonls",
        config = {
                cmd = { "vscode-json-language-server", "--stdio" },
                filetypes = { "json", "jsonc" },
                root_markers = { ".git" },
        },
}
