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
                ------------------- 脚本 / 解释型语言 -------------------
                python    = "cd $dir && python3 -u $fileName",
                javascript= "cd $dir && node $fileName",
                typescript= "cd $dir && deno run $fileName",
                lua       = "cd $dir && lua $fileName",
                php       = "cd $dir && php $fileName",
                sh        = "cd $dir && bash $fileName",
                zsh       = "cd $dir && zsh $fileName",
                ruby      = "cd $dir && ruby $fileName",

                ------------------- 编译型语言 -------------------
                c = {
                        "cd $dir &&",
                        "gcc -std=c99 -Wall $fileName -o /tmp/$fileNameWithoutExt &&",
                        "/tmp/$fileNameWithoutExt",
                        "&& rm /tmp/$fileNameWithoutExt"
                },
                cpp = {
                        "cd $dir &&",
                        "g++ -std=c++17 $fileName -o /tmp/$fileNameWithoutExt &&",
                        "/tmp/$fileNameWithoutExt",
                        "&& rm /tmp/$fileNameWithoutExt"
                },
                rust = {
                        "cd $dir &&",
                        "rustc $fileName &&",
                        "./$fileNameWithoutExt",
                        "&& rm ./$fileNameWithoutExt"
                },
                go = "cd $dir && go run $fileName",
                java = {
                        "cd $dir &&",
                        "javac $fileName &&",
                        "java $fileNameWithoutExt"
                },
                cs = "cd $dir && dotnet run",
                cs_file = "cd $dir && csc $fileName && mono $fileNameWithoutExt.exe",

                ------------------- 标记语言 / 预览 -------------------
                markdown = "cd $dir && glow -p $fileName",
                html = "cd $dir && xdg-open $fileName 2>/dev/null",
                xml = "cd $dir && xmllint --format $fileName",
                json = "cd $dir && jq . $fileName",
                css = "cd $dir && echo 'CSS 无法直接运行，请配合 HTML 使用'",
                yaml = "cd $dir && yamllint $fileName",

                ------------------- 数据库 / 查询 -------------------
                sql = "cd $dir && sqlite3 < $fileName",

                ------------------- 配置 / 其他 -------------------
                toml = "cd $dir && taplo lint $fileName",
                vim = "cd $dir && echo 'Vimscript 无法直接运行，请使用 :source %'",
                ini = "cd $dir && echo 'INI 文件无需运行'",
        },

        before_run_filetype = function()
                vim.cmd("write")
        end,
})
