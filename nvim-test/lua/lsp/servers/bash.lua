return {
        name = "bashls",
        config = {
                cmd = { "bash-language-server", "start" },
                filetypes = { "sh", "zsh" },
                root_markers = { ".git" },
        },
}
