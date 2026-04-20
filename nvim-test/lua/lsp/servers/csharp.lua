return {
        name = "omnisharp",
        config = {
                cmd = { "omnisharp", "--languageserver" },
                filetypes = { "cs" },
                root_markers = { "*.sln", "*.csproj", ".git" },
        },
}
