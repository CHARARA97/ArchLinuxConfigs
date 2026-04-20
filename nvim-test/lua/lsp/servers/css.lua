return {
        name = "cssls",
        config = {
                cmd = { "vscode-css-language-server", "--stdio" },
                filetypes = { "css", "scss", "less" },
                root_markers = { ".git" },
        },
}
