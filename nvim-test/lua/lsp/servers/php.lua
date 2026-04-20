return {
        name = "intelephense",
        config = {
                cmd = { "intelephense", "--stdio" },
                filetypes = { "php" },
                root_markers = { "composer.json", ".git" },
        },
}
