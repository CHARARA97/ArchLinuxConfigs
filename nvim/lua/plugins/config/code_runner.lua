require('code_runner').setup({
        mode = "float",         -- 可选: float, toggleterm, tab, split, vimux, better_term
        focus = true,           -- 执行后是否自动聚焦到终端窗口
        startinsert = true,     -- 是否进入插入模式（仅对 term/tab 有效）

        float = {
                border = "rounded",   -- 边框：none, single, double, rounded, solid, shadow
                width = 0.85,        -- 占编辑器宽度的 85%
                height = 0.7,        -- 占编辑器高度的 70%
                x = 0.5, y = 0.5,   -- 居中显示
                border_hl = "FloatBorder", -- 边框高亮组
        },

        filetype = {
                ------------------- 脚本/解释型语言 -------------------
                python    = "cd $dir && python3 -u $fileName",
                javascript= "cd $dir && node $fileName",
                typescript= "cd $dir && deno run $fileName",      -- 也可用 ts-node
                lua       = "cd $dir && lua $fileName",
                ruby      = "cd $dir && ruby $fileName",
                php       = "cd $dir && php $fileName",
                perl      = "cd $dir && perl $fileName",
                r         = "cd $dir && Rscript $fileName",
                sh        = "cd $dir && bash $fileName",          -- 通用 shell 脚本
                zsh       = "cd $dir && zsh $fileName",
                fish      = "cd $dir && fish $fileName",
                ps1       = "cd $dir && pwsh $fileName",          -- PowerShell Core

                ------------------- 编译型语言 -------------------
                -- C: 编译并运行，生成可执行文件到 /tmp 并自动删除
                c = {
                    "cd $dir &&",
                    "gcc -std=c99 -Wall *.c -o /tmp/$fileNameWithoutExt &&",
                    "/tmp/$fileNameWithoutExt",
                    "&& rm /tmp/$fileNameWithoutExt"
                },

                -- C++: 使用 g++，支持 C++17
                cpp = {
                        "cd $dir &&",
                        "g++ -std=c++17 $fileName -o /tmp/$fileNameWithoutExt &&",
                        "/tmp/$fileNameWithoutExt",
                        "&& rm /tmp/$fileNameWithoutExt"
                },

                -- Rust: 两种风格，此处用 rustc 直接编译运行（适合单文件）
                rust = {
                        "cd $dir &&",
                        "rustc $fileName &&",
                        "./$fileNameWithoutExt",
                        "&& rm ./$fileNameWithoutExt"
                },
                -- 若项目使用 Cargo，建议通过项目级配置调用 `cargo run`

                -- Go: 直接 go run
                go = "go run",

                -- Java: 注意：文件必须和类名一致，且无包声明时有效
                java = {
                        "cd $dir &&",
                        "javac $fileName &&",
                        "java $fileNameWithoutExt"
                },
                -- 如需处理带包名的 Java，请参考下文“函数式动态命令”

                -- Zig: 直接运行
                zig = "zig run",

                -- Haskell: 使用 runhaskell
                haskell = "runhaskell",

                -- Kotlin: 需先编译再运行
                kotlin = {
                        "cd $dir &&",
                        "kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar &&",
                        "java -jar $fileNameWithoutExt.jar",
                        "&& rm $fileNameWithoutExt.jar"
                },

                -- Scala: 简单脚本用 scala-cli
                scala = "scala-cli run .",

                ------------------- 标记语言/预览型 -------------------
                -- 配合钩子函数可实现自动刷新，此处仅示例
                markdown = "glow -p $fileName",   -- 需安装 glow
                latex    = "pdflatex $fileName",  -- 生成 PDF，建议用 Hook 触发

                ------------------- 数据库 -------------------
                sql      = "sqlite3 < $fileName", -- 示例，需自定义
        },

        -- 6. 运行前自动保存文件（实用钩子）
        before_run_filetype = function()
                vim.cmd("write")
        end,
})
