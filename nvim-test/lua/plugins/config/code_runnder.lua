require('code_runner').setup({
        mode = "tab",

        float = {
                border = "rounded",
                width = 0.85,
                height = 0.7,
                x = 0.5, y = 0.5,
                border_hl = "FloatBorder",
        },

        filetype = {
                python = "python3 -u $fileName",
                javascript = "node $fileName",
                typescript = "deno run $fileName",
                lua = "lua $fileName",
                sh = "bash $fileName",
                cpp = {
                        "cd $dir &&",
                        "g++ -std=c++17 *.cpp -o /tmp/$fileNameWithoutExt &&",
                        "/tmp/$fileNameWithoutExt",
                        "&& rm /tmp/$fileNameWithoutExt"
                },
                rust = {
                        "cd $dir &&",
                        "rustc $fileName &&",
                        "./$fileNameWithoutExt",
                        "&& rm ./$fileNameWithoutExt"
                },
                java = {
                        "cd $dir &&",
                        "javac $fileName &&",
                        "java $fileNameWithoutExt"
                },
                go = "go run $fileName",
        },
        before_run_filetype = function()
                vim.cmd("write")
        end,
})
