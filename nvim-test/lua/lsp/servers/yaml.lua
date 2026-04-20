return {
        name = "yamlls",
        config = {
                cmd = { "yaml-language-server", "--stdio" },
                filetypes = { "yaml", "yml" },
                root_markers = { ".git" },
        },
}
